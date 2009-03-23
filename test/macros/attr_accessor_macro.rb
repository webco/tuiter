class Test::Unit::TestCase
  def self.should_attr_accessor_for(klass, *attributes)
    
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
end