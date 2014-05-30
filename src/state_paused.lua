state_paused = {}

function state_paused:draw () 
 love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",0,0,love.graphics.getWidth(), love.graphics.getHeight())
  
 love.graphics.setColor(255,255,255)
    love.graphics.setFont(bigFont);

  love.graphics.printf("Paused", 0,love.graphics.getWidth()/4, love.graphics.getWidth(), "center") 


end


