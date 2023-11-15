# frozen_string_literal: true

require 'spec_helper'

RSpec.describe T::Genetics do
  it 'has a version number' do
    expect(T::Genetics::VERSION).to be_a(String)
  end
end
