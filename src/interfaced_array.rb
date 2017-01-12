# An array that only accepts objects that comply to a certain interface
class InterfacedArray < Array
  def initialize(interface:)
    @interface = interface
  end

  def << item
    if @interface && !matches_interface?(item)
      fail "#{item} is missing #{missing_methods(item)} to comply with #{@interface}"
    end

    super(item)
  end

  private

  def matches_interface?(item)
    missing_methods(item).empty?
  end

  def missing_methods(item)
    required_methods.each_with_object([]) do |method_name, memo|
      memo << method_name unless item.respond_to?(method_name)
    end
  end

  def required_methods
    @interface.public_instance_methods - Object.public_instance_methods
  end
end
