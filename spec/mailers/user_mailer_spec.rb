require File.dirname(__FILE__) + '/../spec_helper'

describe UserMailer do
  before(:each) do
    @user = Factory(:user)
  end
  describe "initial registration email" do
    it "should render successfully" do
      lambda {UserMailer.registration_confirmation(@user)}.should_not raise_error  
    end
    it "should render successfully" do
      lambda {UserMailer.registration_confirmation(@user).deliver}.should_not raise_error  
    end
    it "generates a multipart message (plain text and html)" do
      @registration_mail=UserMailer.registration_confirmation(@user)
      @registration_mail.body.parts.length.should == 2
      @registration_mail.body.parts.collect(&:content_type).should == ["text/plain; charset=UTF-8" , "text/html; charset=UTF-8"]
    end
    it "should contain the user name" do
      @registration_mail=UserMailer.registration_confirmation(@user)
      @registration_mail.body.parts.find {|p| p.content_type.match /html/}.body.raw_source.should have_selector("p", :content  => @user.name)
    end
  end
  describe "forgot password email" do
    it "should render successfully" do
      lambda {UserMailer.forgot_password(@user)}.should_not raise_error  
    end
    it "should render successfully" do
      lambda {UserMailer.forgot_password(@user).deliver}.should_not raise_error  
    end
    it "generates a multipart message (plain text and html)" do
      @forgot_password_mail=UserMailer.forgot_password(@user)
      @forgot_password_mail.body.parts.length.should == 2
      @forgot_password_mail.body.parts.collect(&:content_type).should == ["text/plain; charset=UTF-8" , "text/html; charset=UTF-8"]
    end
    it "should contain the user name" do
      @forgot_password=UserMailer.forgot_password(@user)
      @forgot_password.body.parts.find {|p| p.content_type.match /html/}.body.raw_source.should have_selector("p", :content  => @user.name)
    end
  end
end
#describe OrderMailer do
# 
#  describe "receipt" do
# 
#    before(:each) do
#      @order = mock_model(Order)
#      @order.customer = mock_model(Customer)
#    end
# 
#    it "should render successfully" do
#      lambda { OrderMailer.create_receipt(@order) }.should_not raise_error
#    end
# 
#    describe "rendered without error" do
#   
#      before(:each) do
#        @mailer = OrderMailer.create_receipt(@order)
#      end
#   
#      it "should have an order number" do
#        @mailer.body.should have_tag('.order_number', :text => @order.id)
#      end
#   
#      it "should have order details" do
#        @mailer.body.should have_tag(".order_details")
#      end
# 
#      it "should have a billing address" do
#        @mailer.body.should have_tag(".billing.address")
#      end
#   
#      it "should have a delivery address" do
#        @mailer.body.should have_tag(".delivery.address")
#      end
# 
#      it "should have customer contact details" do
#        @mailer.body.should have_tag("#contact_details") do
#          with_tag('.landline', :text => @order.customer.landline)
#          with_tag('.mobile', :text => @order.customer.mobile)
#          with_tag('.email', :text => @order.customer.email)
#        end
#      end
# 
#      it "should have a list of items" do
#        @mailer.body.should have_tag(".line_items")
#      end
# 
#      it "should have totals" do
#        @mailer.body.should have_tag(".totals") do
#          with_tag('.sub_total', :text => format_price(@order.sub_total))
#          with_tag('.vat', :text => format_price(@order.vat))
#          with_tag('.postage', :text => format_price(@order.postage))
#          with_tag('.total', :text => format_price(@order.total))
#        end
#      end
#     
#      it "should deliver successfully" do
#        lambda { OrderMailer.deliver(@mailer) }.should_not raise_error
#      end
#     
#      describe "and delivered" do
#       
#        it "should be added to the delivery queue" do
#          lambda { OrderMailer.deliver(@mailer) }.should change(ActionMailer::Base.deliveries,:size).by(1)
#        end
#       
#      end
#   
#    end
#
#  end
# 
#end