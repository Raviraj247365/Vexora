Firebase Integration
--------------------

Purpose:
- Notes and helper scripts for Firebase Auth and Storage integration.

Folder role:
- place service account secrets (outside VCS) and SDK helpers here.

Notes:
- Never check service account JSON into source control.

Running the Firebase emulator locally
------------------------------------

1. Install the Firebase CLI locally: `npm install -g firebase-tools`
2. From the repo root run (or use the `firebase-emulator` service in `docker-compose.yml`):

```bash
# using host machine
firebase emulators:start --only auth,storage --project your-project-id

# or via docker-compose (will run the CLI inside a container)
docker-compose up firebase-emulator
```

3. The default ports used in this repo:
- Auth emulator: `http://localhost:9099`
- Storage emulator: `http://localhost:9199`

Place actual production Firebase service account JSON outside the repo and set `FIREBASE_SERVICE_ACCOUNT_PATH` in your service env.
