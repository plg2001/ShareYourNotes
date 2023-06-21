Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, "966286591191101", "5e60b0ee01bba2ce41ec8c996b1f3c16"
end