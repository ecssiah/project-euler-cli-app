module ProjectEulerCli

class Page

  PROBLEMS_PER_PAGE = 50

  @@total = 0
  @@visited = []

  def self.total
    @@total
  end

  def self.total=(total)
    @@total = total
  end

  def self.visited
    @@visited
  end

  def self.visited=(visited)
    @@visited = visited
  end

end

end
