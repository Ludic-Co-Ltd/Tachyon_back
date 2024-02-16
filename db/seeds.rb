# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

case Rails.env
  when "development"
    Admin.create!([
      {
        email: 'admin@gmail.com',
        password: 'admin123',
        user_name: 'Admin',
        first_name: '馨太',
        last_name: '野中',
      },
      {
        email: 'kuroki@gmail.com',
        password: 'admin123',
        user_name: 'Admin',
        first_name: '凜',
        last_name: '黒木',
      },
    ])

    Mentor.create!([
      {
        email:'mentor1@gmail.com',
        password:'admin123',
        user_name:'mentor1',
        first_name:'馨太1',
        last_name:'野中1',
        birth_date:'2024-01-01',
        gender:1,
        university:'東京大学1',
        faculty:'情報学部1',
        department:'情報学科1',
        graduation_year:2024,
        job_offer_1:'MMB, BIG4',
        job_offer_2:'Shopify',
        zoom_url:'https://zoom.com',
        line_url:'https://line.com',
        timerex_url:'https://timerex.com',
        timerex_url_short:'https://timerex_short.com',
        self_introduction:'テキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキスト'
      },
      {
        email:'mentor2@gmail.com',
        password:'admin123',
        user_name:'mentor2',
        first_name:'馨太2',
        last_name:'野中2',
        birth_date:'2024-01-01',
        gender:2,
        university:'東京大学2',
        faculty:'情報学部2',
        department:'情報学科2',
        graduation_year:2024,
        job_offer_1:'MMB, BIG4',
        job_offer_2:'Shopify',
        zoom_url:'https://zoom.com',
        line_url:'https://line.com',
        timerex_url:'https://timerex.com',
        timerex_url_short:'https://timerex_short.com',
        self_introduction:'テキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキスト'
      },
      {
        email:'mentor3@gmail.com',
        password:'admin123',
        user_name:'mentor3',
        first_name:'馨太3',
        last_name:'野中3',
        birth_date:'2024-01-01',
        gender:1,
        university:'東京大学3',
        faculty:'情報学部3',
        department:'情報学科3',
        graduation_year:2024,
        job_offer_1:'MMB, BIG4',
        job_offer_2:'Shopify',
        zoom_url:'https://zoom.com',
        line_url:'https://line.com',
        timerex_url:'https://timerex.com',
        timerex_url_short:'https://timerex_short.com',
        self_introduction:'テキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキストテキスト'
      },  
    ])
  
    Industry.create!([
      {
        name: '外資系投資銀行'
      },
      {
        name: '戦略コンサル'
      },
      {
        name: '総合コンサル'
      },
      {
        name: '総合商社'
      },
      {
        name: '総合デベロッパー'
      },
      {
        name: '金融'
      },
      {
        name: '広告'
      },
      {
        name: 'IT'
      },      
      {
        name: 'メガベンチャー'
      },      
    ])

    User.create!(
      {
        mentor_id:1,
        email:'moonrider@gmail.com',
        password:'admin123',
        first_name:'馨太',
        last_name:'野中',
        birth_date:'2024-01-01',
        gender:1,
        status:1,
        university:'東京大学',
        faculty:'情報学部',
        department:'情報学科',
        graduation_year:2024,
        industry_id_1:1,
        industry_id_2:2,
      }
    )

    # Company.create!([
    #   {
    #     industry_id:1,
    #     name: 'company1',
    #     overview:'題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名',
    #     logo_path:'uploads/companies/20231219_185449.png'
    #   },
    #   {
    #     industry_id:5,
    #     name: 'company2',
    #     overview:'題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名',
    #     logo_path:'uploads/companies/20231219_185449.png'
    #   },
    #   {
    #     industry_id:3,
    #     name: 'company3',
    #     overview:'題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名',
    #     logo_path:'uploads/companies/20231219_185449.png'
    #   },
    #   {
    #     industry_id:1,
    #     name: 'company4',
    #     overview:'題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名',
    #     logo_path:'uploads/companies/20231219_185449.png'
    #   },
    #   {
    #     industry_id:7,
    #     name: 'company5',
    #     overview:'題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名題名',
    #     logo_path:'uploads/companies/20231219_185449.png'
    #   }, 
    # ])

    # Event.create!([
    #   {
    #     company_id: 1,
    #     mentor_id: 1,
    #     name: 'moon',
    #     image_path: 'uploads/events/20231222_110435.png',
    #     materials_path: 'uploads/events/20231222_110435.png',
    #     overview: 'This is a overview!',
    #     rating: 5,
    #     event_date: '2024-03-01',
    #     start_time: '08:00:00',
    #     end_time: '16:00:00',
    #     event_type: 1,
    #     open_chat_url: 'https://open_chat_url',
    #     zoom_url: 'https://zoom.us/zoom_url',
    #   },
    #   {
    #     company_id: 2,
    #     mentor_id: 2,
    #     name: 'rider',
    #     image_path: 'uploads/events/20231222_110435.png',
    #     materials_path: 'uploads/events/20231222_110435.png',
    #     overview: 'This is a overview',
    #     rating: 4,
    #     event_date: '2024-03-05',
    #     start_time: '08:00:00',
    #     end_time: '18:00:00',
    #     event_type: 2,
    #     open_chat_url: 'https://open_chat_url',
    #     zoom_url: 'https://zoom.us/zoom_url',
    #   },
    #   {
    #     company_id: 3,
    #     mentor_id: 2,
    #     name: 'nonaka',
    #     image_path: 'uploads/events/20231222_110435.png',
    #     materials_path: 'uploads/events/20231222_110435.png',
    #     overview: 'これは素晴らしいです。',
    #     rating: 5,
    #     event_date: '2024-08-03',
    #     start_time: '18:00:00',
    #     end_time: '19:00:00',
    #     event_type: 1,
    #     open_chat_url: 'https://open_chat_url',
    #     zoom_url: 'https://zoom.us/zoom_url',
    #   },
    #   {
    #     company_id: 2,
    #     mentor_id: 1,
    #     name: 'sksoai',
    #     image_path: 'uploads/events/20231222_110435.png',
    #     materials_path: 'uploads/events/20231222_110435.png',
    #     overview: 'これは素晴らしいです。',
    #     rating: 5,
    #     event_date: '2024-08-07',
    #     start_time: '08:00:00',
    #     end_time: '20:00:00',
    #     event_type: 3,
    #     open_chat_url: 'https://open_chat_url',
    #     zoom_url: 'https://zoom.us/zoom_url',
    #   }
    # ])
end
