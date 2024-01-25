Map api = {
  "auth": {
    "base_url": "http://127.0.0.1:8000/auth",
    "endpoints": {
      "logout": "token/destroy/",
      "signup": "users/",
      "signin": "jwt/create/"
    }
  },
  "app": {
    "base_url": "https://stable-baselines.readthedocs.io",
  },
};
