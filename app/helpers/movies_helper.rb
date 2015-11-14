module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def hilite_class(col)
    if(params[:sort].to_s == col)
      return 'hilite'
    else
      return nil
    end    
  end
end
