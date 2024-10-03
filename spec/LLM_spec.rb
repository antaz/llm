# frozen_string_literal: true

RSpec.describe LLM do
  it "has a version number" do
    expect(LLM::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
