class Validator
  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  #A class of 2D array holding the information about used numbers. Array 0 is used for rows, 1-3 for blocks and 4-13 for columns.
  #Each array contains 9 spaces, that represents the numbers used in the row/block/column in aggragated one-hot coding. 
  class SudokuCheckingArray

  def initialize()
    @counterarray = Array.new(13){Array.new(9,0)}
  end

  #When adding number, check if it hasnt been used. If it has we return a false value.
  def addToColumn(column,nr)
    @counterarray[4+column][nr] += 1
    if @counterarray[4+column][nr] == 2 then
      return false
    end
  end

  def addToBlock(block,nr)
    @counterarray[1+block][nr] += 1
    if @counterarray[1+block][nr] == 2 then
      return false
    end
  end

  def addToRow(nr)
    @counterarray[0][nr] += 1
    if @counterarray[0][nr] == 2 then
      return false
    end
  end

  #To save memory space the arrays will be reused when possible.
  def cleanRow()
    @counterarray[0].map! {|item| item = 0}
  end

  def cleanBlocks()
    @counterarray[1].map! {|item| item = 0}
    @counterarray[2].map! {|item| item = 0}
    @counterarray[3].map! {|item| item = 0}
  end

  #This method was used in debugging while coding.
  def printArray()
    print @counterarray
    puts ""
    puts ""
  end
  end

  def validate 
    checkarray = SudokuCheckingArray.new()
    
    #Cleaning up the input data removing any unneeded information.
    cleanedsudoku = @puzzle_string.gsub("-", "").gsub("|", "").gsub("+", "").gsub("\n", "").gsub(" ", "")

    counter = 0
    is_incomplete = false

    #Checking each symbol once.
    cleanedsudoku.split("").each do |n|

      #If there is a 0 dont count it anywhere, but take note that puzzle is incomplete.
      if n == '0' then
      is_incomplete = true

      else 
      #Otherwise we add the number to row/column/block that the number is a part of. This method can return false value
      #in which case the puzzle isnt valid.
      if checkarray.addToRow(n.to_i-1) == false or 
      checkarray.addToColumn(counter%9,n.to_i-1) == false or
      checkarray.addToBlock(((counter%9)/3.to_f).floor,n.to_i-1) == false
      then return "Sudoku is invalid." 
      end
      end

      #When finishing a row (9 symbols), clean up the row array, since it cant become invalid if already valid. It can be reused for the next row. 
      counter += 1
      if counter%9 == 0 then 
          checkarray.cleanRow()
      end
      #When finishing row of block (27 symbols 3*9*9), clean up the block array, same reason as rows.
      if counter%27 == 0 then
          checkarray.cleanBlocks()
      end
    end

#Check if we found a 0, if so puzzle is incomplete but valid. Otherwise its valid.
if is_incomplete then
  return("Sudoku is valid but incomplete.")
else
  return("Sudoku is valid.")
end
end
end