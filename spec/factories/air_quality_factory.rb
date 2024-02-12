FactoryBot.define do
  factory :air_quality do
    location
    aqi { 1 }
    pm2_5 { 1.5 }
    pm10 { 1.5 }
    co { 1.5 }
    so2 { 1.5 }
    no2 { 1.5 }
    o3 { 1.5 }
    measured_at { "2024-02-11 20:50:07" }
    nh3 { 1.5 }
    no { 1.5 }
  end
end
