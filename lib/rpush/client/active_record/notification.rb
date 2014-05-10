module Rpush
  module Client
    module ActiveRecord
      class Notification < ::ActiveRecord::Base
        include Rpush::MultiJsonHelper
        include Rpush::Client::ActiveModel::Notification

        self.table_name = 'rpush_notifications'

        # TODO: Dump using multi json.
        serialize :registration_ids

        belongs_to :app, class_name: 'Rpush::Client::ActiveRecord::App'

        if Rpush.attr_accessible_available?
          attr_accessible :badge, :device_token, :sound, :alert, :data, :expiry,:delivered,
            :delivered_at, :failed, :failed_at, :error_code, :error_description, :deliver_after,
            :alert_is_json, :app, :app_id, :collapse_key, :delay_while_idle, :registration_ids, :uri
        end

        def data=(attrs)
          return unless attrs
          raise ArgumentError, "must be a Hash" if !attrs.is_a?(Hash)
          write_attribute(:data, multi_json_dump(attrs.merge(data || {})))
        end

        def registration_ids=(ids)
          ids = [ids] if ids && !ids.is_a?(Array)
          super
        end

        def data
          multi_json_load(read_attribute(:data)) if read_attribute(:data)
        end
      end
    end
  end
end
