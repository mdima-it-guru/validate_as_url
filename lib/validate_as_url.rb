module ValidateAsUrl

	#require 'resolv'

	MessageScope = defined?(ActiveModel) ? :activemodel : :activerecord

	#LocalPartSpecialChars = /[\!\#\$\%\&\'\*\-\/\=\?\+\-\^\_\`\{\|\}\~]/

	def self.validate_as_url(url, options={})
		options ||={}

		default_options = {
			message_invalid: ::I18n.t(:invalid_url, :scope => [MessageScope, :errors, :messages], :default => 'does not appear to be valid url'),
			message_nil:  ::I18n.t(:invalid_url, :scope => [MessageScope, :errors, :messages], :default => 'cannot be null'),
			message_blank: ::I18n.t(:invalid_url, :scope => [MessageScope, :errors, :messages], :default => 'cannot be blank'),
			allow_nil: false,
			allow_blank: false
		}
		opts = options.merge(default_options) # merge the default options into the specified options, retaining all specified options

		if opts[:allow_nil] == false
			if url.nil?
				return [ opts[:message_nil] ]
			end
		end

		url = url.to_s.strip

		if opts[:allow_blank] == false
			if url.blank?
				return [ opts[:message_blank] ]
			end
		end

		unless url =~ /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix
			return [ opts[:message_invalid] ]
		end

		return nil    # represents no validation errors
	end


	module Validations
		def validate_as_url(*attr_names)
			options = { :on => :save,
			            :allow_nil => false,
			            :allow_blank => false }
			options.update(attr_names.pop) if attr_names.last.is_a?(Hash)

			validates_each(attr_names, options) do |record, attr_name, value|
				errors = ::ValidateAsUrl::validate_as_url(value.to_s, options)
				errors.each do |error|
					record.errors.add(attr_name, error)
				end unless errors.nil?
			end
		end
	end
end

if defined?(ActiveModel)
	class AsUrlValidator < ActiveModel::EachValidator
		def validate_each(record, attribute, value)
			err = ::ValidateAsUrl::validate_as_url(value, options)
			unless err.nil?
				record.errors[attribute] << err
				record.errors[attribute].flatten!
			end
		end
	end

	module ActiveModel::Validations::HelperMethods
		def validate_as_url(*attr_names)
			validates_with ::AsUrlValidator, _merge_attributes(attr_names)
		end
	end
else
	if defined?(ActiveRecord)
		class ActiveRecord::Base
			extend ::AsUrlValidator::Validations
		end
	end
end
