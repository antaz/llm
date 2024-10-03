# frozen_string_literal: true

RSpec.describe LLM do
  it "has a version number" do
    expect(LLM::VERSION).not_to be nil
  end
end
