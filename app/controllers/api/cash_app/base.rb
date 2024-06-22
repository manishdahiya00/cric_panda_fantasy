module API
  module CashApp
    class Base < Grape::API
      mount API::CashApp::V1::Userdetails
      mount API::CashApp::V1::Appdetails
      mount API::CashApp::V1::Gameplays
    end
  end
end
