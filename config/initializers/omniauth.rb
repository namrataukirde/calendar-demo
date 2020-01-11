Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, "1096327935695-0dsqjl1k8j6vuahpfralpkjpopnloj1f.apps.googleusercontent.com", "MCMZYkU8eJSCqOfXC7M0333d", {scope: "userinfo.email, calendar"}
end
