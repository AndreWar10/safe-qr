# Safe QR Backend

Backend service responsible for analyzing QR code payloads detected by the Safe QR mobile app. The service exposes a REST API that accepts QR data and returns a safety report.

## Features
- REST endpoint to analyze QR code content
- Heuristic- and reputation-based scoring for URLs
- Configurable threat indicators (phishing keywords, suspicious TLDs, etc.)
- Structured response describing the risk score and mitigation hints
- Ready to deploy as a stateless container or run locally

## Getting Started
```bash
# Install dependencies
dart pub get

# Run the development server
dart run bin/server.dart
```

Set environment variables in a `.env` file when needed (e.g. API keys for external reputation services).

```env
PORT=8080
LOG_LEVEL=INFO
```

## API
- `POST /api/v1/analyze`
  - Body: `{ "payload": "string" }`
  - Response: `{ "isSafe": true, "riskScore": 12, "verdict": "trusted", "indicators": [] }`

## Testing
```bash
dart test
```

## Folder Structure
- `bin/` - entrypoint and server bootstrap
- `lib/core/` - configuration, logging utilities, shared helpers
- `lib/domain/` - pure business logic (entities, services, value objects)
- `lib/infrastructure/` - integrations with third-party services or data sources
- `lib/presentation/` - HTTP adapters, routing, middlewares
- `test/` - unit tests

## Roadmap
- Integrate external threat intelligence providers
- Persist historical scans for auditing
- Expose WebSocket channel for streaming updates
