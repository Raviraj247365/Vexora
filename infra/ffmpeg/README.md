FFmpeg Helpers
--------------

Purpose:
- Scripts and Dockerfile to run FFmpeg-based video processing tasks.

Folder role:
- `Dockerfile` for packaging FFmpeg tooling
- `scripts/` for common FFmpeg command examples

Notes:
- Keep heavy processing in backend or worker services, not on mobile devices.
