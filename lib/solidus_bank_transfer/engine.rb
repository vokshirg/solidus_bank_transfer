# frozen_string_literal: true

module SolidusBankTransfer
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'solidus_bank_transfer'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    initializer 'spree.register.payment_methods', after: "spree.register.payment_methods" do |app|
      config.to_prepare do
        app.config.spree.payment_methods << ::Spree::PaymentMethod::BankTransfer
      end
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
