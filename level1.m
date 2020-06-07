function example

%--------------------------------------------------------------------------
%Snake
%Version 1.00
%Created by Stepen
%Created 26 November 2011
%Last modified 4 December 2012
%--------------------------------------------------------------------------
%Snake starts GUI game of classic snake.
%--------------------------------------------------------------------------
%How to play Snake:
%Player collects score by controlling the snake's movement using w-s-a-d
%button or directional arrow button to the food while avoid crashing the
%walls and its own tail. Use shift to speed up your snake, ctrl to slow
%down your snake, and p to pause your game.
%--------------------------------------------------------------------------

%CodeStart-----------------------------------------------------------------
%Reseting MATLAB environment
    close all
    clear all
%Declaring global variables
    playstat=0;
    pausestat=0;
    quitstat=0;
    field=zeros(50);
    arenaindex=1;
    snakePos=zeros(15,2);
    snakevel=1;
    snakeDir='right';
    trueDir='right';
    snakeScore=5;
    foodpos=zeros(3,2);
%Defining variables for deffield
    deffield=cell(1,3);
    deffield{1}=zeros(50);
    
%Generating GUI
    ScreenSize=get(0,'ScreenSize');
    mainwindow=figure('Name','�g�Y�D�j��',...
                      'NumberTitle','Off',...
                      'Menubar','none',...
                      'Resize','off',...
                      'color',[0 0 0],...
                      'Units','pixels',...
                      'Position',[0.5*(ScreenSize(3)-800),...
                                  0.5*(ScreenSize(4)-600),...
                                  800,650],...
                      'WindowKeyPressFcn',@pressfcn,...
                      'DeleteFcn',@closegamefcn);
                  
loading=uicontrol('Parent',mainwindow,...
              'Style','text',...
              'String','Loading ... 0 %',...
              'Visible','on',...
              'FontSize',20,...
              'HorizontalAlignment','center',...
              'BackgroundColor',[0 0 0],...
              'ForegroundColor',[1,1,1],...
              'Units','pixels',...
              'Position',[250,50,300,50]);
          
loadingSnake=axes('Parent',mainwindow,...
              'Visible','on',...
              'Units','pixels',...
              'Position',[-150,400,160,10]);
          loadingsnakegraphics=zeros(10,150,3);
          loadingsnakegraphics(:,1:140,2)=0.8;
          loadingsnakegraphics(:,1:140,3)=0.2;
          loadingsnakegraphics(:,141:150,2)=0.5;
          loadingsnakegraphics(:,141:150,3)=0;
          imshow(loadingsnakegraphics)
          
for i=1:100
    set(loading,'String',sprintf('Loading ... %s %s',num2str(i),'%'))
    set(loadingSnake,'Position',[-150+4.75*i,150,150,10])
    pause(0.01)
end
pause(0.5)
    set(loading,'Visible','off');
    
for i=1:100
    set(mainwindow,'color',[52 / 25500*i,73 / 25500*i,94/25500*i])
    pause(0.01)
end
    pause(0.05)
    axes('Parent',mainwindow,...
         'Units','pixel',...
         'Position',[75,20,650,550]);

    scoreText=uicontrol('Parent',mainwindow,...
                         'Style','text',...
                         'String',snakeScore,...
                         'FontSize',30,...
                         'FontWeight','bold',...
                         'HorizontalAlignment','center',...
                         'BackgroundColor',[0,0.8,0.2],...
                         'Units','pixels',...
                         'Position',[359,580,85,51]);

                    
    

    field=generatefieldarray(deffield,snakePos,foodpos);
    drawfield(field)
    startgamefcn();
    
    function field=generatefieldarray(deffield,snakePos,foodpos)
        field=deffield{arenaindex};
        for count=1:length(snakePos)
            if ~((snakePos(count,1)==0)||(snakePos(count,2)==0))
                field(snakePos(count,1),snakePos(count,2))=1;
                if count==1
                    field(snakePos(1,1),snakePos(1,2))=2;
                end
            end
        end
        for count=1:length(foodpos)
            if ~((foodpos(count,1)==0)||(foodpos(count,2)==0))
                field(foodpos(count,1),foodpos(count,2))=5;
            end
        end
    end

    function drawfield(field)
        %Preparing array for field graphic
        graphics=uint8(zeros(500,500,3));
        %Calculating field graphic array
        for row=1:50
        for col=1:50
            %Drawing wall
            if field(row,col)==9
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,1)=0;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,2)=0;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,3)=0;
            end
            %Drawing snake  GREEN
            if field(row,col)==1
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,1)=52;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,2)=152;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,3)=219;
            end
            %Drawing snake's head GREEN
            if field(row,col)==2
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,1)=42;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,2)=128;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,3)=185;
            end
            %Drawing food
            if field(row,col)==5
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,1)=192;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,2)=57;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,3)=43;
            end
            %Drawing ground
            if field(row,col)==0
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,1)=26;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,2)=188;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,3)=156;
            end
        end
        end
        %Drawing graphic
        imshow(graphics)
    end
    function pressfcn(~,event)
        switch event.Key
            case 'w'
                if ~strcmpi(trueDir,'down')
                    snakeDir='up';
                end
            case 's'
                if ~strcmpi(trueDir,'up')
                    snakeDir='down';
                end
            case 'a'
                if ~strcmpi(trueDir,'right')
                    snakeDir='left';
                end
            case 'd'
                if ~strcmpi(trueDir,'left')
                    snakeDir='right';
                end
            case 'return'
                startgamefcn;
            case 'escape'
                closegamefcn;
        end
    end
    function startgamefcn(~,~)
        %Resetting variables
        playstat=1;
        snakePos=zeros(15,2);
        snakePos(:,1)=21;
        snakePos(:,2)=22:-1:8;
        snakeDir='right';
        %Initiating graphics
        field=generatefieldarray(deffield,snakePos,foodpos);
        drawfield(field)
        %Placing initial food
        count=1;
        while count<4
            foodpos(count,1)=1+round(49*rand);
            foodpos(count,2)=1+round(49*rand);
            if field(foodpos(count,1),foodpos(count,2))==0
                count=count+1;
            end
        end
        %Redrawing graphics
        field=generatefieldarray(deffield,snakePos,foodpos);
        drawfield(field)
        %Performing loop for the game
        while playstat==1
            %Creating loop for game pause
            while pausestat
                pause(0.01)
            end
            %Calculating snake's forward movement
            %%%%%%%  SNAKE 1  %%%%%%%%%
            if strcmpi(snakeDir,'left')
                nextmovepos1=[snakePos(1,1),snakePos(1,2)-1];
                trueDir='left';
                if nextmovepos1(2)==0
                    nextmovepos1(2)=50;
                end
            elseif strcmpi(snakeDir,'right')
                nextmovepos1=[snakePos(1,1),snakePos(1,2)+1];
                trueDir='right';
                if nextmovepos1(2)==51
                    nextmovepos1(2)=1;
                end
            elseif strcmpi(snakeDir,'up')
                nextmovepos1=[snakePos(1,1)-1,snakePos(1,2)];
                trueDir='up';
                if nextmovepos1(1)==0
                    nextmovepos1(1)=50;
                end
            elseif strcmpi(snakeDir,'down')
                nextmovepos1=[snakePos(1,1)+1,snakePos(1,2)];
                trueDir='down';
                if nextmovepos1(1)==51
                    nextmovepos1(1)=1;
                end
            end
            
            %Checking snake's forward movement position for food
            %%%%%%snake1
            if field(nextmovepos1(1),nextmovepos1(2))==5
                growstat1=1;
                %Deleting eaten food
                for count=1:3
                    if isequal(nextmovepos1,foodpos(count,:))
                        foodpos(count,:)=[];
                        break
                    end
                end
                %Adding new food
                addstat=1;
                while addstat==1
                    foodpos(3,1)=1+round(49*rand);
                    foodpos(3,2)=1+round(49*rand);
                    if field(foodpos(3,1),foodpos(3,2))==0
                        addstat=0;
                    end
                end
            else
                growstat1=0;
            end
            
            if (field(nextmovepos1(1),nextmovepos1(2))==1)||...
               (field(nextmovepos1(1),nextmovepos1(2))==3)||...
               (field(nextmovepos1(1),nextmovepos1(2))==9)
                playstat=0;
                failed
                break
            end
            
            %Moving snake forward
            if growstat1==1
                snakePos=[nextmovepos1;snakePos(1:length(snakePos),:)];
                snakeScore=snakeScore-1;
            else
                snakePos=[nextmovepos1;snakePos(1:length(snakePos)-1,:)];
            end
            
            %Updating graphics
            field=generatefieldarray(deffield,snakePos,foodpos);
            drawfield(field)
            %Performing delay
%             set(scoreText,'String',num2str(snakeScore))
            % Finish the game, go to next level
            set(scoreText,'String',num2str(snakeScore))
            if snakeScore<=0
                playstat=0;
                transition1
            end
            pause(0.11-snakevel*0.01)
        end
    end

    function closegamefcn(~,~)
        %Stopping game loop
        playstat=0;
        quitstat=1;
        pause(0.5)
        %Closing all windows
        delete(mainwindow)
    end

end