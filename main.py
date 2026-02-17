from flask import Flask, request, Response
import requests
import json

app = Flask(__name__)

OLLAMA_API = "http://127.0.0.1:11434/api/generate"

# ✅ Allowed subjects & terms
ALLOWED_KEYWORDS = [
    "physics", "chemistry", "biology", "math", "mathematics",
    "botany", "zoology", "class 11", "class 12", "11", "12",
    "motion", "force", "cell", "atom", "equation", "energy",
    "newton", "law", "velocity", "acceleration", "photosynthesis",
    "electricity", "magnetism", "reaction", "molecule", "bond", "current"
]


@app.route("/ask", methods=["POST"])
def ask():
    data = request.json or {}
    prompt = data.get("prompt", "").strip().lower()

    # 🚫 Instantly block unrelated questions
    if not any(word in prompt for word in ALLOWED_KEYWORDS):
        return Response(
            "🚫 Sorry, I can only answer questions related to Class 11 & 12 Physics, Chemistry, Biology, or Mathematics.",
            mimetype="text/plain"
        )

    def stream():
        try:
            # ⚡ Call Ollama quickly (limit size)
            r = requests.post(
                OLLAMA_API,
                json={
                    "model": "phi3",   # use full model
                    "prompt": prompt,
                    "num_predict": 250,
                    "temperature": 0.5
                },
                stream=True,
                timeout=25
            )

            for line in r.iter_lines():
                if line:
                    try:
                        chunk = json.loads(line.decode("utf-8"))
                        if "response" in chunk:
                            yield chunk["response"]
                    except Exception:
                        continue
        except requests.exceptions.Timeout:
            yield "\n⏳ Timeout: AI took too long to respond.\n"
        except Exception as e:
            yield f"\n❌ Error: {str(e)}\n"

    return Response(stream(), mimetype="text/plain")

# ✅ Warm-up to prevent first-time lag
if __name__ == "__main__":
    print("🧠 Warming up model...")
    try:
        requests.post(
            OLLAMA_API,
            json={"model": "phi3", "prompt": "Hello"},
            timeout=8
        )
        print("✅ Model ready! 🚀")
    except Exception as e:
        print("⚠️ Warmup failed:", e)

    app.run(host="127.0.0.1", port=8000)
