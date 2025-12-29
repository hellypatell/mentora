# fixoratry

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Python](https://img.shields.io/badge/Python-3.9+-green)
![AI](https://img.shields.io/badge/AI-Offline%20LLM-purple)
![Platform](https://img.shields.io/badge/Platform-Android-lightgrey)
![Status](https://img.shields.io/badge/Status-Active-success)

# 📘 Mentora – Your Personal Offline AI Mentor

Mentora is a **student-focused offline-first AI learning application** designed to help students **learn, revise, and practice** efficiently. It combines **AI-powered answers**, **personal notes**, and **chapter-wise quizzes** into one simple and distraction-free platform.

---

## 🌟 Vision

> **Mentora: Your Personal Offline AI Mentor – helping students learn, revise, and practice through AI answers, personal notes, and quizzes, all in one place.**

Mentora aims to support students even in **low or no internet environments**, making quality learning accessible anytime, anywhere.

---

## 📝 Project Abstract

Mentora is an **offline-first AI-powered learning application** developed to support students in learning, revising, and practicing academic content without continuous internet dependency. The application integrates a **Flutter-based mobile frontend** with a **Python Flask backend** connected to a **local Large Language Model (LLM) using Ollama**. By leveraging locally stored PDFs as a knowledge base, Mentora delivers fast and reliable AI responses even in low-connectivity environments.

The system offers a unified learning experience through three core modules: **Ask to AI** for concept clarification, **Notes Management** for personalized offline note-taking, and **Chapter-wise Quizzes** for self-assessment with score tracking. Designed with a clean, student-friendly interface, Mentora minimizes distractions while maximizing learning efficiency.

The project demonstrates practical implementation of **offline AI**, **mobile application development**, and **local model integration**, making it suitable as a **final-year academic project** as well as a foundation for real-world educational tools.

---

## 🧠 Key Features

### 🔹 Ask to AI (Offline)

* Fast offline AI responses using **local PDFs**
* Integrated with **local Ollama AI model** via Flask backend
* No internet required for core learning

### 🔹 Notes Management

* Create, edit, and delete personal notes
* Fully offline storage
* Helpful for revision and quick reference

### 🔹 Quiz Module

* Subject-wise and chapter-wise quizzes
* Score tracking for self-evaluation
* Helps reinforce learning through practice

### 🔹 Clean Student-Friendly UI

* Splash / Onboarding screens
* Simple subject → chapter navigation
* Distraction-free design focused on learning

---

## 📱 Application Modules

* Splash / Onboarding Page
* Login & Registration Page
* Home Page (Subject → Chapter)
* Ask to AI Page (Offline AI support)
* Notes Page (CRUD operations)
* Quiz Page (with score tracking)
* Settings Page
* Admin Page (optional – content management)
* PDF Reader (optional – integrated with Ask to AI)

---

## 🛠️ Tech Stack

### Frontend

* **Flutter** (Cross-platform mobile development)

### Backend

* **Flask (Python)**
* Connects the app with local AI model

### AI Model

* **Ollama (Local LLM)**
* Offline AI responses from study PDFs

### Storage

* Local device storage (Offline-first approach)

---

## 🚀 Future Enhancements

* Smart AI tools: Simplify, Summarize, Text-to-Speech
* "Quiz Me" feature directly from AI answers
* Save AI answers as notes
* Offline ↔ Online AI toggle
* Chat history for Ask to AI
* Engagement features: streaks, badges, fun facts
* Subject-based UI themes and animations

---

## ⚙️ Installation & Run Steps

Follow the steps below to install and run **Mentora** on your system. These steps are written so that even beginners can follow them easily using the **Command Prompt (CMD)**.

---

### 🔧 Prerequisites

Make sure the following tools are installed on your system:

* Flutter SDK
* Android Studio (with emulator) **or** a physical Android device
* Python 3.9+
* Ollama (Local LLM runtime)
* Git (optional, for cloning repository)

Verify installations using CMD:

```
flutter --version
python --version
ollama --version
```

---

### 📥 Step 1: Get the Project Files

If using Git:

```
git clone <your-repository-url>
cd mentora
```

Or:

* Download the ZIP file
* Extract it
* Open the project folder

---

### 📱 Step 2: Run Flutter App (Frontend)

Open **Command Prompt** and navigate to the Flutter project folder:

```
cd mentora_flutter
```

Get dependencies:

```
flutter pub get
```

Check connected devices:

```
flutter devices
```

Run the app:

```
flutter run
```

---

### 🤖 Step 3: Setup & Run AI Backend (Flask)

Open **another CMD window** and navigate to backend folder:

```
cd mentora_backend
```

Install required Python packages:

```
pip install flask
pip install flask-cors
pip install requests
```

Run Flask server:

```
python main.py
```

If successful, you will see:

```
Running on http://127.0.0.1:5000
```

---

### 🧠 Step 4: Run Ollama Local AI Model

Open **CMD / Terminal** and start Ollama:

```
ollama run llama3
```

(You can replace `llama3` with your preferred local model)

---

### 🔗 Step 5: Connect App with Backend

* Make sure Flask server is running
* Make sure Ollama is running
* Ensure the API URL in Flutter matches Flask server (e.g. `http://10.0.2.2:5000` for emulator)

---

### ✅ Final Run Checklist

* Flutter app running ✔️
* Flask backend running ✔️
* Ollama model running ✔️

Now open the app and use **Ask to AI**, Notes, and Quiz features **offline** 🎉

---

## 🎯 Target Users

* College students
* Offline learners
* Students preparing for exams
* Learners who want AI help without internet dependency

---

## 📂 Project Structure (High Level)

* Flutter App (UI + Logic)
* Flask Backend (`main.py`)
* Local AI Model (Ollama)
* PDF Knowledge Base

---

## 📌 Why Mentora?

* Works **offline**
* Designed **specifically for students**
* Combines **AI + Notes + Quizzes** in one app
* Ideal for **final-year projects and real-world use**

---

## 👩‍💻 Developed By

**Helly Patel**
MCA Student
Project: *Mentora – Offline AI Learning App*

---

## 📄 License

This project is developed for **educational and academic purposes**.

---

✨ *Mentora is not just an app, it’s your personal learning companion.*


A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
