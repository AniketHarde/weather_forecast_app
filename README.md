# 🌦️ Weather Forecast App

A lightweight, scalable Ruby on Rails application that accepts a ZIP code, fetches real-time weather data using the OpenWeatherMap API, and caches the result for 30 minutes using Redis.

> 🧪 Built using Test-Driven Development (TDD) with RSpec, designed for production-grade enterprise practices.

---

## 📦 Features

- Accepts ZIP code input via UI
- Retrieves:
  - Current temperature
  - High and low temperatures
  - "From cache" indicator
- Caches forecast data per ZIP code for 30 minutes
- Resilient error handling for API/network failures
- Developed with clean architecture and service decomposition

---

## 🛠️ Tech Stack

- **Ruby on Rails 8** (API + UI)
- **HTTParty** – HTTP client for external API
- **Redis** – Cache store for scalability
- **RSpec** – Unit testing framework
- **VCR + WebMock** – Record external API responses for consistent tests
- **Rubocop** – Static code analysis for clean code
- **Rails Credentials** – Secure storage of API keys

---

## 🧱 Architecture & Object Decomposition

### `WeatherService`
- Accepts a ZIP code
- Checks if forecast exists in Redis cache
- If not, fetches from OpenWeatherMap API and caches it
- Returns:
  ```ruby
  {
    temperature: 75.3,
    from_cache: true/false
  }
