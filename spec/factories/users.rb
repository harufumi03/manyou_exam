FactoryBot.define do
  factory :user, class: User do
    name { "" }
    email { "sample@sample.com" }
    password { "111111" }
    password_digest { "111111" }
    admin { false }
  end
end
