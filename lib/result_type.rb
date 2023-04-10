class Result
  Ok = Data.define(:value)
  Err = Data.define(:error)

  def initialize(ok: nil, error: nil)
    @result = if ok
                Ok.new(ok)
              else
                Err.new(error)
              end
  end

  def unwrap()
    @result
  end

  def expect(err_message)
    case @result
    in Ok
      @result
    in Err
      raise err_message
    end
  end

  def or_else()
    case @result
    in Ok
      @result
    in Err
      raise "No block given" unless block_given?
      yield
    end
  end

  def and_then()
    case @result
    in Ok
      raise "No block given" unless block_given?
      yield
    in Err
      @result
    end
  end
  
  def ok?()
    case @result
    in Ok
      true
    in Err
      false
    end
  end

  def err?()
    case @result
    in Ok
      false
    in Err
      true
    end
  end

  def ok_and?(block)
    case @result
    in Ok
      block.call(@result.value)
    in Err
      raise "Result should be Ok, got #{@result.class}" 
    end
  end

  def err_and?(block)
    case @result
    in Ok
      raise "Result should be Err, got #{@result.class}"
    in Err
      block.call(@result.value)
    end
  end
end
