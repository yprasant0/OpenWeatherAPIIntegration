require 'rails_helper'

RSpec.describe AirQuality, type: :model do
  it 'has a valid factory' do
    expect(build(:air_quality)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:location) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:aqi) }
    it { is_expected.to validate_presence_of(:pm2_5) }
    it { is_expected.to validate_presence_of(:pm10) }
    it { is_expected.to validate_presence_of(:co) }
    it { is_expected.to validate_presence_of(:so2) }
    it { is_expected.to validate_presence_of(:no2) }
    it { is_expected.to validate_presence_of(:o3) }
    it { is_expected.to validate_presence_of(:measured_at) }
  end
end
