class Test::Unit::TestCase
  
  def self.should_attr_accessor_for(klass, attributes)
    object = klass.new
    
    attributes.each do |attribute|
      should "respond_to #{attribute}" do
        assert object.respond_to?(attribute)
      end
      
      should "respond_to #{attribute}=" do
        assert object.respond_to?("#{attribute}=")
      end
    end
  end

  def self.should_load_attribute_on_initialize(klass, attributes, expected_value = "value", setter_value = expected_value)
    attributes = [attributes] unless attributes.class == Array
    attributes.each do |attribute|
      should "load attribute '#{attribute}' on initialize" do
        data = eval("{'#{attribute}' => #{setter_value.inspect}}")
        
        object =  klass.new data
        assert_equal(expected_value, object.send(attribute))
      end
    end
  end
  
end