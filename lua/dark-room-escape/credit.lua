credit = {}

function credit.init()
   init = false
   
   massive_font = gr.newFont(120)

end

function credit.update(dt)
      
end

function credit.draw()
   gr.setFont(massive_font)
   gr.setColor( 255,255,255 )
   gr.printf("Thank you for playing our game!", 0, 0, gr.getWidth(), "center")
end
