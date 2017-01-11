module ArrayPermutation
  def next_permutation(first, last)
    i = last-1
    while (i>first && self[i-1] >= self[i]) do
      i -= 1
    end
    return false if i<=first
    j = last-1
    while (self[j] <= self[i-1]) do
      j -= 1
    end
    self[i-1],self[j] = self[j],self[i-1]
    self[i...last] = self[i...last].reverse
    return true
  end

  def prev_permutation(first, last)
    i = last-1
    while (i>first && self[i-1] <= self[i]) do
      i -= 1
    end
    return false if i<=first
    j = last-1
    while (self[j] >= self[i-1]) do
      j -= 1
    end
    self[i-1],self[j] = self[j],self[i-1]
    self[i...last] = self[i...last].reverse
    return true
  end
end

class Array
  include ArrayPermutation
end
