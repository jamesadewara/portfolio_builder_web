Map api = {
  "auth": {
    "base_url": "http://127.0.0.1:8000/auth",
    "endpoints": {
      "logout": "token/destroy/",
      "signup": "users/",
      "signin": "jwt/create/",
      "update": "users/me/",
      "detail": "users/me/",
      "delete": "users/delete/"
    }
  },
  "template": {
    "base_url": "http://127.0.0.1:8000/project",
    "endpoints": {
      "fetch": "templates/",
    }
  },
  "app": {
    "base_url": "https://stable-baselines.readthedocs.io",
    "version": '1.0.0',
    "tutorial": "https://youtu.be/5dQxcmMd5hg?si=y8kJJWN2VwkdHZ7v"
  },
};
