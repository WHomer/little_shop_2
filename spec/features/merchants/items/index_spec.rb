
require 'rails_helper'


RSpec.describe 'As a merchant' do
  describe 'When I visit my items page' do

    before :each do
      @merchant_1 = create(:user, role: 1)
      @merchant_1.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      @merchant_2 = create(:user, role: 1)
      @merchant_2.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      @item_1 = create(:item, user: @merchant_1)
      @item_2 = create(:item, user: @merchant_1)
      @item_3 = create(:item, user: @merchant_1)
      @item_4 = create(:item, user: @merchant_2)
      @item_5 = create(:item, user: @merchant_2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_1)
    end

    it 'I see a list of the items that I have' do
      visit dashboard_items_path

      expect(page).to have_link('Add a new item')

      within "#item-#{@item_1.id}" do
        expect(page).to have_content(@item_1.id)
        expect(page).to have_content(@item_1.name)
        expect(page).to have_content(@item_1.inventory)
        expect(page).to have_content(@item_1.price)
        expect(page).to have_link('Edit this item')
        find "img[src='https://kaaskraam.com/wp-content/uploads/2018/02/Gouda-Belegen.jpg']"
      end

      within "#item-#{@item_2.id}" do
        expect(page).to have_content(@item_2.id)
        expect(page).to have_content(@item_2.name)
        expect(page).to have_content(@item_2.inventory)
        expect(page).to have_content(@item_2.price)
        expect(page).to have_link('Edit this item')
        find "img[src='https://kaaskraam.com/wp-content/uploads/2018/02/Gouda-Belegen.jpg']"
      end

      within "#item-#{@item_3.id}" do
        expect(page).to have_content(@item_3.id)
        expect(page).to have_content(@item_3.name)
        expect(page).to have_content(@item_3.inventory)
        expect(page).to have_content(@item_3.price)
        expect(page).to have_link('Edit this item')
        find "img[src='https://kaaskraam.com/wp-content/uploads/2018/02/Gouda-Belegen.jpg']"
      end

      expect(page).to_not have_content(@item_4.name)
      expect(page).to_not have_content(@item_5.name)
    end
  end

  describe 'When I visit my items page' do

    before :each do
      @merchant_1 = create(:user, role: 1)
      @merchant_1.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      @merchant_2 = create(:user, role: 1)
      @merchant_2.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      @item_1 = create(:item, user: @merchant_1)
      @item_2 = create(:item, user: @merchant_1)
      @item_3 = create(:item, user: @merchant_1, active: false)
      @item_4 = create(:item, user: @merchant_2)
      @item_5 = create(:item, user: @merchant_2)
      @user = create(:user)
      address = @user.user_addresses.create!(nickname: "nickname_1", street_address_1: "street number 1", street_address_2: "apt 1", city: 'city 1', state_province: 'state 1', zip_code: '123123', phone_number: 'phone 1' )
      order_1 = create(:order, user: @user, user_address: address)
      OrderItem.create!(item: @item_2, order: order_1, quantity: 12, price: 1.99, fulfilled: true)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_1)
    end

    it 'has a link to delete the item if no user has ordered this item' do
      # If no user has ever ordered this item, I see a link to delete the item
      visit dashboard_items_path

      within "#item-#{@item_1.id}" do
        expect(page).to have_content(@item_1.id)
        expect(page).to have_content(@item_1.name)
        expect(page).to have_content(@item_1.inventory)
        expect(page).to have_content(@item_1.price)
        expect(page).to have_link('Edit this item')

        expect(page).to have_link('Delete this item')
        find "img[src='https://kaaskraam.com/wp-content/uploads/2018/02/Gouda-Belegen.jpg']"
      end

      within "#item-#{@item_2.id}" do
        expect(page).to have_content(@item_2.id)
        expect(page).to have_content(@item_2.name)
        expect(page).to have_content(@item_2.inventory)
        expect(page).to have_content(@item_2.price)
        expect(page).to have_link('Edit this item')

        expect(page).to_not have_link('Delete this item')
        find "img[src='https://kaaskraam.com/wp-content/uploads/2018/02/Gouda-Belegen.jpg']"
      end
    end

    it 'has a link to enable if the item is disabled' do
      visit dashboard_items_path
      within "#item-#{@item_1.id}" do


        expect(page).to_not have_link('Enable this item')
        find "img[src='https://kaaskraam.com/wp-content/uploads/2018/02/Gouda-Belegen.jpg']"
      end

      within "#item-#{@item_3.id}" do

        expect(page).to have_link('Enable this item')
        find "img[src='https://kaaskraam.com/wp-content/uploads/2018/02/Gouda-Belegen.jpg']"
      end
    end

    it 'has a link to disable if the item is enabled' do
      visit dashboard_items_path
      within "#item-#{@item_1.id}" do

        expect(page).to have_link('Disable this item')
        find "img[src='https://kaaskraam.com/wp-content/uploads/2018/02/Gouda-Belegen.jpg']"
      end

      within "#item-#{@item_3.id}" do

        expect(page).to_not have_link('Disable this item')
        find "img[src='https://kaaskraam.com/wp-content/uploads/2018/02/Gouda-Belegen.jpg']"

      end
    end

    it 'Can disable an item' do
      visit dashboard_items_path
      within "#item-#{@item_1.id}" do

        expect(page).to have_link('Disable this item')

        click_link('Disable this item')
      end

      expect(page).to have_content('This item has been disabled.')
      within "#item-#{@item_1.id}" do
        expect(page).to have_link('Enable this item')
      end
      @item_1.reload
      expect(@item_1.active).to eq(false)
    end

    it 'can delete an item' do
      visit dashboard_items_path

      within "#item-#{@item_1.id}" do
        expect(page).to have_content(@item_1.id)
        expect(page).to have_content(@item_1.name)
        expect(page).to have_content(@item_1.inventory)
        expect(page).to have_content(@item_1.price)

        expect(page).to have_link('Delete this item')
        find "img[src='https://kaaskraam.com/wp-content/uploads/2018/02/Gouda-Belegen.jpg']"

        click_link('Delete this item')
      end

      expect(page).to have_content("Item #{@item_1.id} is now deleted.")
      expect(page).to_not have_content("Item id: #{@item_1.id}")
    end


    it 'Can enable an item' do
      visit dashboard_items_path
      within "#item-#{@item_3.id}" do

        expect(page).to have_link('Enable this item')

        click_link('Enable this item')
      end

      expect(page).to have_content('This item has been enabled.')
      within "#item-#{@item_3.id}" do
        expect(page).to have_link('Disable this item')
      end
      @item_3.reload
      expect(@item_3.active).to eq(true)

    end

    it 'can add an item' do
      visit dashboard_items_path

      click_link('Add a new item')

      expect(current_path).to eq('/dashboard/items/new')

      fill_in 'Name', with: 'Velveeta'
      fill_in 'Description', with: 'Glorified Cheese Wizz.'
      fill_in 'Image', with: 'https://kaaskraam.com/wp-content/uploads/2018/02/Gouda-Belegen.jpg'
      fill_in 'Price', with: '3.90'
      fill_in 'Inventory', with: '25'


      click_button 'Create Item'


      expect(current_path).to eq(dashboard_items_path)
      expect(page).to have_content('The item was created successfully.')

      @lastitem = Item.last

      within "#item-#{@lastitem.id}" do
        expect(page).to have_content(@lastitem.id)
        expect(page).to have_content(@lastitem.name)
        expect(page).to have_content(@lastitem.inventory)
        expect(page).to have_content(@lastitem.price)

        expect(page).to have_link('Disable this item')
        expect(page).to have_link('Delete this item')
        find "img[src='https://kaaskraam.com/wp-content/uploads/2018/02/Gouda-Belegen.jpg']"
      end
    end


    it 'Allows blank image' do
      visit dashboard_items_path

      click_link('Add a new item')

      expect(current_path).to eq('/dashboard/items/new')

      fill_in 'Name', with: 'Velveeta'
      fill_in 'Description', with: 'Glorified Cheese Wizz.'
      fill_in 'Image', with: ''
      fill_in 'Price', with: '3.90'
      fill_in 'Inventory', with: '25'


      click_button 'Create Item'


      expect(current_path).to eq(dashboard_items_path)
      expect(page).to have_content('The item was created successfully.')

      @lastitem = Item.last

      within "#item-#{@lastitem.id}" do
        expect(page).to have_content(@lastitem.id)
        expect(page).to have_content(@lastitem.name)
        expect(page).to have_content(@lastitem.inventory)
        expect(page).to have_content(@lastitem.price)

        expect(page).to have_link('Disable this item')
        expect(page).to have_link('Delete this item')
        find "img[src='https://kaaskraam.com/wp-content/uploads/2018/02/Gouda-Belegen.jpg']"
      end
    end

    it 'Wont allow prices below 0' do
      visit dashboard_items_path

      click_link('Add a new item')

      expect(current_path).to eq('/dashboard/items/new')

      fill_in 'Name', with: 'Velveeta'
      fill_in 'Description', with: 'Glorified Cheese Wizz.'
      fill_in 'Image', with: ''
      fill_in 'Price', with: '-3.90'
      fill_in 'Inventory', with: '25'

      click_button 'Create Item'


      expect(current_path).to eq(dashboard_items_path)
      expect(page).to_not have_content('The item was created successfully.')
      expect(page).to have_content('Price must be greater than 0')
    end

    it 'Wont allow inventory below 0' do
      visit dashboard_items_path

      click_link('Add a new item')

      expect(current_path).to eq('/dashboard/items/new')

      fill_in 'Name', with: 'Velveeta'
      fill_in 'Description', with: 'Glorified Cheese Wizz.'
      fill_in 'Image', with: ''
      fill_in 'Price', with: '3.90'
      fill_in 'Inventory', with: '-25'

      click_button 'Create Item'

      expect(current_path).to eq(dashboard_items_path)
      expect(page).to_not have_content('The item was created successfully.')
      expect(page).to have_content('Inventory must be greater than 0')
    end

    it 'Can go to the edit page link' do
      visit dashboard_items_path


      within "#item-#{@item_1.id}" do
        click_link('Edit this item')
      end

      expect(current_path).to eq("/dashboard/items/#{@item_1.id}/edit")
    end

    it 'Has a form to modify the item information' do
      visit "/dashboard/items/#{@item_1.id}/edit"

      expect(page).to have_content("Edit #{@item_1.name}'s Information")

      expect(page).to have_field("Name")
      expect(page).to have_field("Description")
      expect(page).to have_field("Image")
      expect(page).to have_field("Price")
      expect(page).to have_field("Inventory")

      expect(page).to have_button("Edit Item")
    end

    it 'Has a form to modify the item information' do
      visit "/dashboard/items/#{@item_1.id}/edit"

      expect(page).to have_content("Edit #{@item_1.name}'s Information")

      expect(page).to have_field("Name")
      expect(page).to have_field("Description")
      expect(page).to have_field("Image")
      expect(page).to have_field("Price")
      expect(page).to have_field("Inventory")

      expect(page).to have_button("Edit Item")
    end

    it 'Form fields are pre-populated with prior information' do
      visit "/dashboard/items/#{@item_1.id}/edit"
      expect(page).to have_field("Name", with: "#{@item_1.name}")
      expect(page).to have_field("Description", with: "#{@item_1.description}")
      expect(page).to have_field("Image", with: "#{@item_1.image}")
      expect(page).to have_field("Price", with: "#{@item_1.price}")
      expect(page).to have_field("Inventory", with: "#{@item_1.inventory}")
    end

    it 'Edit information' do
      visit edit_dashboard_item_path(@item_1)

      fill_in 'Name', with: 'Velveeta'
      fill_in 'Description', with: 'Glorified Cheese Wizz.'
      fill_in 'Image', with: 'https://kaaskraam.com/wp-content/uploads/2018/02/Gouda-Belegen.jpg'
      fill_in 'Price', with: '5.50'
      fill_in 'Inventory', with: '32'

      click_button 'Edit Item'

      expect(current_path).to eq(dashboard_items_path)
      expect(page).to have_content('The item was updated.')
    end

    it 'Retains its prior enabled/disabled state and thumbnail image is replaced' do
      visit edit_dashboard_item_path(@item_1)

      fill_in 'Name', with: 'Velveeta'
      fill_in 'Description', with: 'Glorified Cheese Wizz.'
      fill_in 'Image', with: ''
      fill_in 'Price', with: '5.50'
      fill_in 'Inventory', with: '32'

      click_button 'Edit Item'

      expect(@item_1.active).to eq(true)
      expect(page).to have_content('The item was updated.')
      within "#item-#{@item_1.id}" do
        find "img[src='https://kaaskraam.com/wp-content/uploads/2018/02/Gouda-Belegen.jpg']"
      end
    end

    it 'Has error messages if unable to save.' do
      visit edit_dashboard_item_path(@item_1)

      fill_in 'Name', with: ''
      fill_in 'Description', with: ''
      fill_in 'Image', with: ''
      fill_in 'Price', with: '-5.50'
      fill_in 'Inventory', with: '-3.20'

      click_button 'Edit Item'

      expect(@item_1.active).to eq(true)
      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content("Description can't be blank")
      expect(page).to have_content("Price must be greater than 0")
      expect(page).to have_content("Inventory must be greater than 0")

    end
  end
end