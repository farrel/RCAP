require 'date'
require 'assistance'
require 'uuidtools'
require 'yaml'
require 'json'
require 'rexml/document'
require 'rcap/utilities'
require 'rcap/validations'
require 'rcap/alert'
require 'rcap/parameter'
require 'rcap/event_code'
require 'rcap/info'
require 'rcap/resource'
require 'rcap/point'
require 'rcap/circle'
require 'rcap/polygon'
require 'rcap/geocode'
require 'rcap/area'

module RCAP
	XMLNS = "urn:oasis:names:tc:emergency:cap:1.1"
  CAP_VERSION = "1.1"
	VERSION = "0.4"
end
