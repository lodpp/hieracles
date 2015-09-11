require 'spec_helper'

describe Hieracles::Node do
  let(:options) {
    { 
      config: File.expand_path('../../files/config.yml', __FILE__),
      hierafile: File.expand_path('../../files/hiera.yaml', __FILE__),
      encpath: File.expand_path('../../files/enc', __FILE__),
      basepath: File.expand_path('../../files', __FILE__)
    }
  }

  context "when extra parameters are specified" do
    describe '.new' do
      let(:extraoptions) {
        #options.merge({ 'key1' => 'value1', 'key2' => 'value2' })
        options.merge({ params: 'key1=value1;key2=value2' })
      }
      let(:node) { Hieracles::Node.new 'server.example.com', extraoptions }
      let(:expected) {
        { 
          fqdn: 'server.example.com',
          country: 'fr',
          datacenter: 'equinix',
          farm: 'dev',
          key1: 'value1',
          key2: 'value2'
        }
      }
      it { expect(node).to be_a Hieracles::Node }
      it { expect(node.hiera_params).to eq expected }
    end
  end

  context "when parameters are valid" do
    let(:node) { Hieracles::Node.new 'server.example.com', options }

    describe '.new' do
      let(:expected) {
        { 
          fqdn: 'server.example.com',
          country: 'fr',
          datacenter: 'equinix',
          farm: 'dev'
        }
      }
      it { expect(node).to be_a Hieracles::Node }
      it { expect(node.hiera_params).to eq expected }
    end

    describe '.files' do
      let(:expected) {
        [
          'nodes/server.example.com.yaml',
          'farm/dev.yaml'
        ]
      }
      it { expect(node.files).to eq expected }
    end

    describe '.paths' do
      let(:expected) {
        [
          File.join(node.hiera.datadir, 'nodes/server.example.com.yaml'),
          File.join(node.hiera.datadir, 'farm/dev.yaml')
        ]
      }
      it { expect(node.paths).to eq expected }
    end

    describe '.params' do
      let(:expected) {
        [
          [ "another.sublevel.thing", 
            [{
              value: "always",
              file: File.join(node.hiera.datadir, 'nodes/server.example.com.yaml')
            }]
          ],
          [ "common_param.subparam",
            [{
              value: "overriden", 
              file: File.join(node.hiera.datadir, 'nodes/server.example.com.yaml')
            }]
          ], 
          [ "somefarmparam", 
            [{
              value: false,
              file: File.join(node.hiera.datadir, 'farm/dev.yaml')
            }]
          ]
        ]
      }
      it { expect(node.params).to eq expected }
    end

    describe '.params_tree' do
      let(:expected) {
        {
          "another" => { 
            "sublevel" => {
              "thing" => "always"
            }
          },
          "common_param" => {
            "subparam" => "overriden"
          }, 
          "somefarmparam" => false
        }
      }
      it { expect(node.params_tree).to eq expected }
    end
  end

  describe '.modules' do
  end

  describe '.info' do
    let(:node) { Hieracles::Node.new 'server.example.com', options }
    let(:expected) { {
      fqdn: 'server.example.com'
    } }
  end

  describe '.populate_info' do
  end

  describe '.populate_from_encdir' do
  end

  describe '.poopulate_files' do
  end

  describe '.addfile' do
  end

  describe '.classpath' do
  end

  describe '.modulepath' do
  end

  describe '.populate_params' do
  end

  describe '.populate_params_tree' do
  end

  describe '.populate_modules' do
  end

  describe '.add_modules' do
  end



end
