# TalaTask API

A Ruby on rails API for task assignment optimization.

## Features

- Employee management with skills and availability
- Task creation with required skills and duration
- Automatic task assignment based on employee availability and skills
- Assignment reporting system
- JSON:API standardization
- Swagger documentation

## Setup

1. Start the server:
```bash
docker compose up --build
```

2. Install dependencies:
```bash
docker compose run web bundle install
```

## API Documentation

Access the Swagger documentation at `http://localhost:3000/api-docs`


## Architecture

The application follows these design patterns and principles:

- Service Objects for complex business logic
- JSON:API serialization for standardized responses
- RESTful API design
- Modular and maintainable code structure