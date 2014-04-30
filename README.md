RCAP - Common Alerting Protocol for Ruby
========================================

Overview
--------

The Common Alerting Protocol is a lightweight standard to facilitate the distribution of alerting data. RCAP is an implementation of the CAP document protocol in Ruby. It allows for the creation of RCAP messages from Ruby applications and the parsing of external messages.

RCAP currently supports CAP 1.0, 1.1 and 1.2.

Dependencies
------------

RCAP depends on the following gems

* [Assistance](http://assistance.rubyforge.org)
* [UUIDTools](http://uuidtools.rubyforge.org)
* [JSON](http://json.rubyforge.org)

RCAP uses the REXML API, included in Ruby, to parse and generate XML.

Installation
------------

RCAP is distributed as a Ruby gem and is available from [Rubygems.org](http://rubygems.org). From the command line you can install it with the gem command:

    gem install rcap

The gem is also available for download and manual installation at [www.aimred.com/gems](http://www.aimred.com/gems).

Usage
-----

### Creating an Alert

RCAP uses a 'builder' style syntax to create alerts. 

    require 'rcap'

    alert = RCAP::CAP_1_2::Alert.new do |alert|
      alert.sender   = 'cape_town_disaster_relief@capetown.municipal.za'
      alert.status   = Alert::STATUS_ACTUAL
      alert.msg_type = Alert::MSG_TYPE_ALERT
      alert.scope    = Alert::SCOPE_PUBLIC 
    
      alert.add_info do |info|
        info.event       = 'Liquid Petroleoum Tanker Fire'
        info.language    = 'en-ZA'
        info.categories  << Info::CATEGORY_TRANSPORT
        info.categories  << Info::CATEGORY_FIRE 
        info.urgency     = Info::URGENCY_IMMEDIATE
        info.severity    = Info::SEVERITY_SEVERE
        info.certainty   = Info::CERTAINTY_OBSERVED
        info.headline    = 'LIQUID PETROLEOUM TANKER FIRE ON N2 INCOMING FREEWAY'
        info.description = 'A liquid petroleoum tanker has caught fire on the N2 incoming freeway 1km
                            after the R300 interchange.  Municipal fire fighting crews have been dispatched.
                            Traffic control officers are on the scene and have diverted traffic onto
                            alternate routes.' 
    
        info.add_area do |area|
          area.area_desc = 'N2 Highway/R300 Interchange' 
          area.add_geocode do |geocode|
            geocode.name  = 'Intersection'
            geocode.value = 'N2-15' 
          end
        end
      end
    end
   
    # Accessing attributes
    puts alert.status                 # "Actual"
    info = alert.infos.first
    puts info.language                # "en-ZA"
    puts info.categories.join( ', ' ) # "Transport, Fire"
    puts info.areas.first             # "N2 Highway/R300 Interchange"

### Exporting an Alert

Using the alert message created earlier

    puts alert.to_xml

Will print the following CAP XML

    <?xml version='1.0'?>
    <alert xmlns='urn:oasis:names:tc:emergency:cap:1.2'>
      <identifier>494207a7-f86b-4060-8318-a4b2a3ce565e</identifier>
      <sender>cape_town_disaster_relief@capetown.municipal.za</sender>
      <sent>2009-10-26T21:04:51+02:00</sent>
      <status>Actual</status>
      <msgType>Alert</msgType>
      <scope>Public</scope>
      <info>
        <language>en-ZA</language>
        <category>Transport</category>
        <category>Fire</category>
        <event>Liquid Petroleoum Tanker Fire</event>
        <urgency>Immediate</urgency>
        <severity>Severe</severity>
        <certainty>Observed</certainty>
        <headline>LIQUID PETROLEOUM TANKER FIRE ON N2 INCOMING FREEWAY</headline>
        <description>
          A liquid petroleoum tanker has caught fire on the N2 incoming freeway 1km
          after the R300 interchange. Municipal fire fighting crews have been
          dispatched. Traffic control officers are on the scene and have diverted
          traffic onto alternate routes.
        </description>
      </info>
    </alert>

### Parsing an Alert From An External Source

To ensure the correct RCAP Alert object (RCAP::CAP_1_1::Alert or RCAP::CAP_1_2::Alert) is returned from an external source, a number of factories are defined in the RCAP::Alert module. If the version of the document to be parsed can not be ascertained a CAP 1.2 document will be assumed.

To parse an alert from a XML:

    alert = RCAP::Alert.from_xml( xml_string )

### Validation

The RCAP API aims to codify as many of the rules of the CAP XML format into validation rules. The following Info object has two attributes ('severity' and 'certainty') set to incorrect values.

    info = RCAP::CAP_1_2::Info.new do |info|
      info.event = 'Liquid Petroleoum Tanker Fire'
      info.language   = 'en-ZA'
      info.categories << Info::CATEGORY_TRANSPORT
      info.urgency    = Info::URGENCY_IMMEDIATE
      info.severity   = nil                   # Severity is not assigned
      info.certainty  = 'Incorrect Certainty' # Certainty is assigned an incorrect value
    end
   
    puts "Is info valid: #{ info.valid? }"
    info.errors.full_messages.each{ |message| puts "Error: #{ message }" }

Will produce the following output:

    Is info valid: false
    Error: severity is not present
    Error: certainty can only be assigned the following values: Observed, Likely, Possible, Unlikely, Unknown

A full spec suite using [RSpec](http://www.rspec.info) was used to test the validations and currently numbers over 1000 tests.

Web resources
-------------

* The RCAP project page can be found at [http://www.aimred.com/projects/rcap](http://www.aimred.com/projects/rcap)
* The RCAP API docs can be found at [http://www.aimred.com/projects/rcap/api](http://www.aimred.com/projects/rcap/api)
* A public git repository can be found at [http://github.com/farrel/RCAP](http://github.com/farrel/RCAP)
* A CAP Validator based on RCAP can be found at [http://capvalidator.herokuapp.com](http://capvalidator.herokuapp.com)

Authors
-------

* Farrel Lifson - farrel.lifson@aimred.com - http://www.aimred.com

### Contributors

* Earle Clubb - http://github.com/eclubb

Change Log
----------

[CHANGELOG](file.CHANGELOG.html)

License
-------

RCAP is released under the BSD License.

Copyright 2010 - 2013 AIMRED CC. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY AIMRED CC ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL AIMRED CC OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those of the authors and should not be interpreted as representing official policies, either expressed or implied, of AIMRED CC.
