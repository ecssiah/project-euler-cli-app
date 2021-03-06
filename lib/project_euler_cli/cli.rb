module ProjectEulerCli #:nodoc:

# Manages the command line interface for the program.
class CLI

  def initialize
    @av = ArchiveViewer.new
    @as = ArchiveSearcher.new
  end

  def start
    banner
    main_menu
  end

  def prompt
    print "e: "
    gets.strip
  end

  def banner
    puts
    puts "  ----------------------------------  "
    puts " [          Project Euler           ] "
    puts " [            e^iπ = -1             ] "
    puts "  ----------------------------------  "
  end

  def main_menu
    puts " -     List recent problems (r)     - "
    puts " -    List archived problems (l)    - "
    puts " -            Search (s)            - "
    puts " -             Exit (x)             - "

    input = prompt

    if input == 'r'
      recent_menu
      main_menu
    elsif input == 'l'
      page_menu(1)
      main_menu
    elsif input == 's'
      search_menu
      main_menu
    elsif input == 'x'
      return
    else
      main_menu
    end
  end

  def recent_menu
    @av.display_recent

    puts
    puts "e(x)it"

    input = prompt

    if input.to_i.between?(Problem.total - 9, Problem.total)
      problem_menu(input.to_i)
    elsif input == 'x'
      return
    else
      recent_menu
    end
  end

  def page_menu(page)
    page = [1, page, Page.total].sort[1] #clamp
    @av.display_page(page)

    puts
    puts "[#{page}/#{Page.total}] (n)ext (p)rev (g)oto e(x)it"

    input = prompt

    first_problem = Page::LENGTH * (page - 1) + 1
    last_problem = Page::LENGTH * page

    if input.to_i.between?(first_problem, last_problem)
      problem_menu(input.to_i)
    elsif input == 'n'
      page_menu(page + 1)
    elsif input == 'p'
      page_menu(page - 1)
    elsif input.start_with?('g')
      page_menu(input.gsub('g', '').to_i)
    elsif input == 'x'
      return
    else
      page_menu(page)
    end
  end

  def problem_menu(id)
    @av.display_problem(id)

    puts
    puts "(b)ack e(x)it"

    input = prompt

    if input == 'b'
      if @as.searching
        search_results_menu
      else
        page = Problem.page(id)
        page == 0 ? recent_menu : page_menu(page)
      end
    elsif input == 'x'
      return
    else
      problem_menu(id)
    end
  end

  def search_menu
    print "search: "

    search_terms = gets.strip
    @as.search(search_terms)
    search_results_menu
  end

  def search_results_menu
    @av.display_custom_page(@as.results)

    puts
    puts "(s)earch e(x)it"

    input = prompt

    if @as.results.include?(input.to_i)
      problem_menu(input.to_i)
    elsif input == 's'
      search_menu
    elsif input == 'x'
      @as.searching = false
      return
    else
      search_results_menu
    end
  end

end

end
