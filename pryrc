class Object
  def local_methods
    (methods - Object.instance_methods).sort
  end

  def try(*a, &b)
    if a.empty? && block_given?
      yield self
    else
      __send__(*a, &b)
    end
  end
end
