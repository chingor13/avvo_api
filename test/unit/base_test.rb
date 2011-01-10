require 'test_helper'

class AvvoApi::BaseTest < Test::Unit::TestCase

  context "A resource that inherits from AvvoApi::Base" do
    
    setup do
      @object = AvvoApi::Lawyer.new
    end
    
    should "hit the Avvo API with the correct URL when saved" do
      stub_request(:post, "https://www.avvo.com/api/1/lawyers.json")
      @object.save
      assert_requested(:post, "https://www.avvo.com/api/1/lawyers.json")
    end

    should "hit the Avvo API with the correct URL when retrieved" do 
      stub_request(:get, "https://www.avvo.com/api/1/lawyers/1.json").to_return(:body => {:id => '1'}.to_json)
      AvvoApi::Lawyer.find(1)
      assert_requested(:get, "https://www.avvo.com/api/1/lawyers/1.json")      
    end

    context "with a belongs_to association and correct parameters" do
      setup do 
        @object = AvvoApi::Specialty.new(:lawyer_id => 2)
      end
      
      should "hit the Avvo API with the correct URL when saved" do
        stub_request(:post, "https://www.avvo.com/api/1/lawyers/2/specialties.json")
        @object.save
        assert_requested(:post, "https://www.avvo.com/api/1/lawyers/2/specialties.json")
      end
      
      should "hit the Avvo API with the correct URL when retrieved" do 
        stub_request(:get, "https://www.avvo.com/api/1/lawyers/2/specialties/3.json").to_return(:body => {:id => '3'}.to_json)
        AvvoApi::Specialty.find(3, :params => {:lawyer_id => 2})
        assert_requested(:get, "https://www.avvo.com/api/1/lawyers/2/specialties/3.json")      
      end

      should "hit the Avvo API with the correct URL when updated" do 
        stub_request(:get, "https://www.avvo.com/api/1/lawyers/2/specialties/3.json").to_return(:body => {:id => '3', :specialty_id => "88", :specialty_id => '88', :specialty_percent => '100'}.to_json)
        license = AvvoApi::Specialty.find(3, :params => {:lawyer_id => 2})
        assert_requested(:get, "https://www.avvo.com/api/1/lawyers/2/specialties/3.json")  
        stub_request(:put, "https://www.avvo.com/api/1/lawyers/2/specialties/3.json")
        license.save
        assert_requested(:put, "https://www.avvo.com/api/1/lawyers/2/specialties/3.json")
      end

      should "set the prefix parameters correctly when saved" do
        stub_request(:post, "https://www.avvo.com/api/1/lawyers/2/specialties.json").to_return(:body => {:id => '2', :specialty_id => "88", :specialty_id => '88', :specialty_percent => '100'}.to_json)
        @object.save
        assert_requested(:post, "https://www.avvo.com/api/1/lawyers/2/specialties.json")

        assert_equal "/api/1/lawyers/2/specialties/2.json", @object.send(:element_path)
      end
      
    end

    context "with a belongs_to hierarchy and correct parameters" do 

      setup do 
        @object = AvvoApi::Phone.new(:doctor_id => 2, :address_id => 3)
      end

      should "hit the Avvo API with the correct URL when saved" do
        stub_request(:post, "https://www.avvo.com/api/1/doctors/2/addresses/3/phones.json")
        @object.save
        assert_requested(:post, "https://www.avvo.com/api/1/doctors/2/addresses/3/phones.json")
      end

      should "hit the Avvo API with the correct URL when updated" do 
        stub_request(:get, "https://www.avvo.com/api/1/doctors/2/addresses/3/phones/4.json").to_return(:body => {:id => '4'}.to_json)
        phone = AvvoApi::Phone.find(4, :params => {:doctor_id => 2, :address_id => 3})
        assert_requested(:get, "https://www.avvo.com/api/1/doctors/2/addresses/3/phones/4.json")

        stub_request(:put, "https://www.avvo.com/api/1/doctors/2/addresses/3/phones/4.json")
        phone.save
        assert_requested(:put, "https://www.avvo.com/api/1/doctors/2/addresses/3/phones/4.json")
      end

      should "set the prefix parameters correctly when saved" do
        stub_request(:post, "https://www.avvo.com/api/1/doctors/2/addresses/3/phones.json").to_return(:body => {:phone_type_id=>2, :id=>4, :phone_number=>"206-728-0588"}.to_json)
        @object.save
        assert_requested(:post, "https://www.avvo.com/api/1/doctors/2/addresses/3/phones.json")

        assert_equal "/api/1/doctors/2/addresses/3/phones/4.json", @object.send(:element_path)
      end
      
      should "hit the Avvo API with the correct URL when retrieved" do 
        stub_request(:get, "https://www.avvo.com/api/1/doctors/2/addresses/3/phones/4.json").to_return(:body => {:id => '4'}.to_json)
        AvvoApi::Phone.find(4, :params => {:doctor_id => 2, :address_id => 3})
        assert_requested(:get, "https://www.avvo.com/api/1/doctors/2/addresses/3/phones/4.json")      
      end
    end

  end
end