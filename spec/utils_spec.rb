require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Chef::Sync::Utils do
  describe "#node_list" do
    it 'should parse node names from list' do
      list = File.read( File.expand_path(File.dirname(__FILE__) + '/fixtures/knife/node_list.txt') )
      Chef::Sync::Utils.expects(:exec_knife_node_list).returns(list)

      names = Chef::Sync::Utils.node_list('production')
      names.should == ["mongo106.dav", "mongo107.dav", "mongo108.dav"]
    end
  end

  describe "#public_hostnames_by_role" do
    it "should extract hostnames from knife search" do
      json = File.read( File.expand_path(File.dirname(__FILE__) + '/fixtures/knife/node_search_ec2.json') )
      Chef::Sync::Utils.expects(:exec_knife_node_search).returns(json)

      hostnames = Chef::Sync::Utils.public_hostnames_by_role('rails_utility', 'production')
      hostnames.should == ["ec2-107-22-89-198.compute-1.amazonaws.com", "ec2-23-20-177-134.compute-1.amazonaws.com"]
    end
  end

  describe "#update_stages_from_chef" do
    before(:each) do
      @stages = YAML.load_file( File.expand_path(File.dirname(__FILE__) + '/fixtures/config/stages.yml') )
      json = File.read( File.expand_path(File.dirname(__FILE__) + '/fixtures/knife/node_search_ec2.json') )
      Chef::Sync::Utils.stubs(:exec_knife_node_search => json)

      Chef::Sync::Utils.update_stages_from_chef(@stages, {'rails_server' => :app})
    end

    it 'should preserve rails_env' do
      @stages['production']['rails_env'].should == 'production'
      @stages['qa']['rails_env'].should == 'qa'
    end

    it 'should update server lists for included roles' do
      expected_hostnames = ["ec2-107-22-89-198.compute-1.amazonaws.com", "ec2-23-20-177-134.compute-1.amazonaws.com"]
      @stages['production']['roles']['app'].should == expected_hostnames
      @stages['qa']['roles']['app'].should == expected_hostnames
    end

    it 'should NOT update server lists for other roles' do
      ios_expected = %w(ios_hostname)
      @stages['production']['roles']['ios'].should == ios_expected
      @stages['qa']['roles']['ios'].should == ios_expected
    end
  end

  describe '#update_mongo_from_chef' do
    before(:each) do
      @mongos = YAML.load_file( File.expand_path(File.dirname(__FILE__) + '/fixtures/config/mongo.yml') )
      json = File.read( File.expand_path(File.dirname(__FILE__) + '/fixtures/knife/node_search_ec2.json') )
      Chef::Sync::Utils.stubs(:exec_knife_node_search => json)

      Chef::Sync::Utils.update_mongo_from_chef(@mongos)
    end

    it 'should preserve defaults' do
      @mongos['defaults']['port'].should == 27017
    end

    it 'should set hosts based on chef nodes' do
      expected_hosts = [["ec2-107-22-89-198.compute-1.amazonaws.com:27017"], ["ec2-23-20-177-134.compute-1.amazonaws.com:27017"]]
      @mongos['production']['hosts'].should == expected_hosts
    end

    it 'should NOT over-write hosts in excluded environments' do
      @mongos['test']['hosts'].should == [['test-host:27017']]
    end
  end
end
