equire 'csv'
require 'pry'
 
class Employee
  attr_reader :names
 
  TAX_RATE = 0.30
 
  def initialize#(base_salary)
    @names = {}
    # @@month_salary = (base_salary / 12).round(2)
  end
 
  def load_employee
 
    CSV.foreach('employee_payroll.csv', headers: true) do |row|
      @last_name = row['last_name']
      @names[@last_name] = [row['year_salary'], 'nil']
    end
    @names
  end
 
  def load_employee_sales(sales)
    sales.each do |key, value|
      @names[key][1] = value.inject(:+)
    end
    @names
  end
 
 
  def self.load_salary
    salaries = []
    CSV.foreach('employee_payroll.csv', headers: true) do |row|
      @salary = row['year_salary'].to_i
      salaries << row['year_salary']
    end
    salaries
  end
 
  def gross_salary(name)
    case
      when name['Lob'] then @@month_salary + ComissionSalesPerson.commission_halfpercent
      when name['Bobby'] then @@month_salary + ComissionSalesPerson.onehalf
      when name['Groundskeeper'] then @@month_salary + ComissionSalesPerson.check_bonus_five
      when name['Wiggum'] then @@month_salary + ComissionSalesPerson.check_bonus_ten
    end
  end
 
 
  def net_pay
 
  end
 
end
 
class Owner
 
  def initialize(sales)
    @total_employee_sales = sales
  end
 
  def employee_sales?
    @total_employee_sales.values.reduce(:+) > 250000
  end
 
  def bonus_owner
    10000
  end
end
 
class CommissionedSalesPerson < Employee
 
  def initialize(sales)
    @employee_sales = sales.reduce(:+)
  end
 
  def self.commission_halfpercent
    0.5 * @employee_sales
  end
 
  def commission_onehalf
    1.5 * @employee_sales
  end
end
 
class Sale
  attr_reader :total_sales
  def initialize
    @total_sales = {}
    employee_sales_list
  end
 
  def employee_sales_list
    CSV.foreach('sales_total.csv', headers: true) do |row|
      @last_name = row['last_name']
      if @total_sales.has_key?(@last_name)
        @total_sales[@last_name] << row['gross_sale_value'].to_i
      else
        @total_sales[@last_name] = [row['gross_sale_value'].to_i]
      end
    end
    @total_sales
  end
end
 
class QuotaSalesPerson
  def initialize(sales)
    @total_sales = sales #total sales different from the total_sales in the "class Sale"
  end
 
  def check_bonus_five
    if  @total_sales['Groundskeeper'].reduce(:+) > 60000
      5000
    else
      0
    end
  end
 
  def check_bonus_ten
    if  @total_sales['Wiggum'].reduce(:+) > 80000
      10000
    else
      0
    end
  end
end
 
class Runner
 
  def initialize
    x=Sale.new
    y=Employee.new
    y.load_employee
    y.load_employee_sales(x.employee_sales_list)
  end
 
  def employee_output
 
end
 
Runner.new
