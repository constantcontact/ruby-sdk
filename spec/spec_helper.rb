#
# spec_helper.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])
require 'constantcontact'


def load_json(file_name)
	json = File.read(File.join(File.dirname(__FILE__), 'fixtures', file_name))
end
