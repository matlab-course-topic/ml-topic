function level3

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
    field=zeros(50);
    arenaindex=1;
    
    snakepos1=zeros(15,2);
    snakepos2=zeros(15,2);
    snakepos3=zeros(15,2);
    
    snakevel=1;
    
    snakedir1='right';
    truedir1='right';
    
    snakedir2='right';
    truedir2='right';
    
    snakedir3='right';
    truedir3='right';
    
    snakescore1=0;
    snakescore2=0;
    foodpos=zeros(3,2);
    
    snake2stat = 1;
    snake3stat = 1;
    
%Defining variables for deffield
    deffield=cell(1,3);
    deffield{1}=zeros(50);
    deffield{2}=zeros(50);
    deffield{2}([1,50],:)=9;
    deffield{2}(:,[1,50])=9;
    deffield{3}=zeros(50);
    deffield{3}([1,50],:)=9;
    deffield{3}(:,[1,50])=9;
    deffield{3}(25,2:22)=9;
    deffield{3}(25,29:49)=9;
    deffield{4}=zeros(50);
    for i=1:20
        deffield{4}(i,i)=9;
        deffield{4}(51-i,51-i)=9;
        deffield{4}(i,51-i)=9;
        deffield{4}(51-i,i)=9;
    end
%Generating GUI
    ScreenSize=get(0,'ScreenSize');
    mainwindow=figure('Name','貪吃蛇大戰',...
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
                  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%做動畫~~~
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% loading
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

loadingsnake1=axes('Parent',mainwindow,...
              'Visible','on',...
              'Units','pixels',...
              'Position',[-150,400,160,10]);
          loadingsnakegraphics=zeros(10,150,3);
          loadingsnakegraphics(:,1:140,2)=0.8;
          loadingsnakegraphics(:,1:140,3)=0.2;
          loadingsnakegraphics(:,141:150,2)=0.5;
          loadingsnakegraphics(:,141:150,3)=0;
          imshow(loadingsnakegraphics)

loadingsnake2=axes('Parent',mainwindow,...
              'Visible','on',...
              'Units','pixels',...
              'Position',[800,400,160,10]);
          loadingsnakegraphics2=zeros(10,150,3);
          loadingsnakegraphics2(:,11:150,1)=0.2;
          loadingsnakegraphics2(:,11:150,2)=0.6;
          loadingsnakegraphics2(:,11:150,3)=1;
          loadingsnakegraphics2(:,1:10,3)=1;
          imshow(loadingsnakegraphics2)
%LOADING BAR & snakes come out and kiss
for i=1:100
    set(loading,'String',sprintf('Loading ... %s %s',num2str(i),'%'))
    set(loadingsnake1,'Position',[-150+4*i,150,150,10])
    set(loadingsnake2,'Position',[800-4*i,150,150,10])
    pause(0.01)
end
pause(0.5)
    set(loading,'Visible','off');
                           %背景'color',[1,0.6,0.784]  pink
                           %貪吃蛇大戰字樣
                           %'Position',[50,557,700,80]
                           %           [50,537,700,100]
                           %'FontSize',50,...
% mainwindow background
for i=1:100
    set(mainwindow,'color',[52 / 25500*i,73 / 25500*i,94/25500*i])
    pause(0.01)
end

    axes('Parent',mainwindow,...
         'Units','pixel',...
         'Position',[75,20,650,550]);

    lscoretext=uicontrol('Parent',mainwindow,...
                         'Style','text',...
                         'String','0',...
                         'FontSize',30,...
                         'FontWeight','bold',...
                         'HorizontalAlignment','center',...
                         'BackgroundColor',[0,0.8,0.2],...
                         'Units','pixels',...
                         'Position',[339,580,85,51]);
    rscoretext=uicontrol('Parent',mainwindow,...
                         'Style','text',...
                         'String','0',...
                         'FontSize',30,...
                         'FontWeight','bold',...
                         'HorizontalAlignment','center',...
                         'BackgroundColor',[0.2,0.6,1],...
                         'Units','pixels',...
                         'Position',[430,580,85,51]);
%Inititiating graphics
    field=generatefieldarray(deffield,snakepos1,snakepos2,snakepos3,foodpos);
    drawfield(field)
    startgamefcn();

%Declaring LocalFunction
    %Start of generatefieldarray
    %%%%% field == 9 --> wall
    function field=generatefieldarray(deffield,snakepos1,snakepos2,snakepos3,foodpos)
        field=deffield{arenaindex};
        for count=1:length(snakepos1)
            if ~((snakepos1(count,1)==0)||(snakepos1(count,2)==0))
                field(snakepos1(count,1),snakepos1(count,2))=1; % snake1 body
                if count==1
                    field(snakepos1(1,1),snakepos1(1,2))=2; % snake1 head
                end
            end
        end
        for count=1:length(snakepos2)
            if ~((snakepos2(count,1)==0)||(snakepos2(count,2)==0))
                field(snakepos2(count,1),snakepos2(count,2))=3; % snake2 body
                if count==1 
                    field(snakepos2(1,1),snakepos2(1,2))=4; % snake2 head
                end
            end
        end
        for count=1:length(snakepos3)
            if ~((snakepos3(count,1)==0)||(snakepos3(count,2)==0))
                field(snakepos3(count,1),snakepos3(count,2))=10; % snake3 body
                if count==1 
                    field(snakepos3(1,1),snakepos3(1,2))=11; % snake3 head
                end
            end
        end
        for count=1:length(foodpos)
            if ~((foodpos(count,1)==0)||(foodpos(count,2)==0))
                field(foodpos(count,1),foodpos(count,2))=5; % food
            end
        end
    end
    %End of generatefieldarray
    
    %Start of drawfield
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
            %%% Draw snake1
            %Drawing snake  GREEN
            if field(row,col)==1
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,1)=0;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,2)=204;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,3)=51;
            end
            %Drawing snake's head GREEN
            if field(row,col)==2
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,1)=0;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,2)=127;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,3)=0;
            end
            %%% End Draw snake1
            
            %%%  Draw snake2
            %Drawing snake 2 BLUE
            if field(row,col)==3
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,1)=51;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,2)=153;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,3)=255;
            end
            %Drawing snake's head 2 BLUE
            if field(row,col)==4
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,1)=0;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,2)=0;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,3)=255;
            end
            %%% End Draw snake2
            
            %%%  Draw snake3
            %Drawing snake 2 RED
            if field(row,col)==10
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,1)=233;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,2)=101;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,3)=101;
            end
            %Drawing snake's head 2 RED
            if field(row,col)==11
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,1)=255;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,2)=0;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,3)=0;
            end
            %%% End Draw snake3
            
            %Drawing food
            if field(row,col)==5
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,1)=255;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,2)=0;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,3)=0;
            end
            %Drawing ground
            if field(row,col)==0
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,1)=255;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,2)=255;
                graphics(((row-1)*10)+1:((row-1)*10)+10,...
                         ((col-1)*10)+1:((col-1)*10)+10,3)=102;
            end
        end
        end
        %Drawing graphic
        imshow(graphics)
    end
    %End of drawfield
%Declaring CallbackFunction
    %Start of pressfcn
    function pressfcn(~,event)
        switch event.Key
            case 'w'
                if ~strcmpi(truedir1,'down')
                    snakedir1='up';
                end
            case 's'
                if ~strcmpi(truedir1,'up')
                    snakedir1='down';
                end
            case 'a'
                if ~strcmpi(truedir1,'right')
                    snakedir1='left';
                end
            case 'd'
                if ~strcmpi(truedir1,'left')
                    snakedir1='right';
                end
            case 'return'
                startgamefcn;
            case 'escape'
                closegamefcn;
        end
    end
    %End of pressfcn
    
    
    
    %Start of startgamefcn
    function startgamefcn(~,~)
        %Locking user interface

        %Resetting variables
        playstat=1;
        
        snakepos1=zeros(15,2);
        snakepos1(:,1)=21;
        snakepos1(:,2)=22:-1:8;
        
        snakepos2=zeros(15,2);
        snakepos2(:,1)=30;
        snakepos2(:,2)=22:-1:8;
        
        snakepos3=zeros(15,2);
        snakepos3(:,1)=39;
        snakepos3(:,2)=22:-1:8;
        
        snakedir1='right';
        snakescore1=0;
        snakescore2=0;
        %Initiating graphics
        field=generatefieldarray(deffield,snakepos1,snakepos2,snakepos3,foodpos);
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
        
        % Automove snake
        function x = dts(x2, y2)
            x = ((x2 - snakepos2(1,1)) ^ 2 + (y2 - snakepos1(1,2)) ^ 2) ^ 0.5;
        end
        % auto end
        
        %Redrawing graphics
        field=generatefieldarray(deffield,snakepos1,snakepos2,snakepos3,foodpos);
        drawfield(field)
        
        %Performing loop for the game
        while playstat==1
            % auto start snake2
            min_distance = min([dts(foodpos(1, 1), foodpos(1, 2)) dts(foodpos(2, 1), foodpos(2, 2)) dts(foodpos(3, 1), foodpos(3, 2))]);
            min_pos = [];
            max_distance = max([dts(foodpos(1, 1), foodpos(1, 2)) dts(foodpos(2, 1), foodpos(2, 2)) dts(foodpos(3, 1), foodpos(3, 2))]);
            max_pos = [];
            if min_distance == dts(foodpos(1, 1), foodpos(1, 2))
                min_pos = foodpos(1,:);
            elseif min_distance == dts(foodpos(2, 1), foodpos(2, 2))
                min_pos = foodpos(2,:);
            elseif min_distance == dts(foodpos(3, 1), foodpos(3, 2))
                min_pos = foodpos(3,:);
            end
            
            if max_distance == dts(foodpos(1, 1), foodpos(1, 2))
                max_pos = foodpos(1,:);
            elseif max_distance == dts(foodpos(2, 1), foodpos(2, 2))
                max_pos = foodpos(2,:);
            elseif max_distance == dts(foodpos(3, 1), foodpos(3, 2))
                max_pos = foodpos(3,:);
            end

            if(min_pos(1) > snakepos2(1,1))
                if ~strcmpi(truedir2,'up')
                    snakedir2='down';
                end
            elseif(min_pos(1) < snakepos2(1,1))
                if ~strcmpi(truedir2,'down')
                    snakedir2='up';
                end
            end

            if(min_pos(2) > snakepos2(1,2))
                if ~strcmpi(truedir2,'left')
                    snakedir2='right';
                end
            elseif(min_pos(2) < snakepos2(1,2))
                if ~strcmpi(truedir2,'right')
                    snakedir2='left';
                end
            end
            %%%%%%%%
            if(max_pos(1) > snakepos3(1,1))
                if ~strcmpi(truedir3,'up')
                    snakedir3='down';
                end
            elseif(max_pos(1) < snakepos3(1,1))
                if ~strcmpi(truedir3,'down')
                    snakedir3='up';
                end
            end

            if(max_pos(2) > snakepos3(1,2))
                if ~strcmpi(truedir3,'left')
                    snakedir3='right';
                end
            elseif(max_pos(2) < snakepos3(1,2))
                if ~strcmpi(truedir3,'right')
                    snakedir3='left';
                end
            end
            % auto end snake2
            
%             % auto start snake3
%             next = round(4*rand);
%             if next == 0
%                 if ~strcmpi(truedir3,'up')
%                     snakedir3='down';
%                 end
%             elseif next == 1
%                 if ~strcmpi(truedir3,'down')
%                     snakedir3='up';
%                 end
%             elseif next == 2
%                 if ~strcmpi(truedir3,'left')
%                     snakedir3='right';
%                 end
%             elseif next == 3
%                 if ~strcmpi(truedir3,'right')
%                     snakedir3='left';
%                 end
%             end
%             % auto end snake3
            
            %Creating loop for game pause

            %Calculating snake's forward movement
            %%%%%%%  SNAKE 1  %%%%%%%%%
            if strcmpi(snakedir1,'left')
                nextmovepos1=[snakepos1(1,1),snakepos1(1,2)-1];
                truedir1='left';
                if nextmovepos1(2)==0
                    nextmovepos1(2)=50;
                end
            elseif strcmpi(snakedir1,'right')
                nextmovepos1=[snakepos1(1,1),snakepos1(1,2)+1];
                truedir1='right';
                if nextmovepos1(2)==51
                    nextmovepos1(2)=1;
                end
            elseif strcmpi(snakedir1,'up')
                nextmovepos1=[snakepos1(1,1)-1,snakepos1(1,2)];
                truedir1='up';
                if nextmovepos1(1)==0
                    nextmovepos1(1)=50;
                end
            elseif strcmpi(snakedir1,'down')
                nextmovepos1=[snakepos1(1,1)+1,snakepos1(1,2)];
                truedir1='down';
                if nextmovepos1(1)==51
                    nextmovepos1(1)=1;
                end
            end
            
            %%%%%%%%%  SNAKE 2  %%%%%%%%%
            if snake2stat == 1
                if strcmpi(snakedir2,'left')
                    nextmovepos2=[snakepos2(1,1),snakepos2(1,2)-1];
                    truedir2='left';
                    if nextmovepos2(2)==0
                        nextmovepos2(2)=50;
                    end
                elseif strcmpi(snakedir2,'right')
                    nextmovepos2=[snakepos2(1,1),snakepos2(1,2)+1];
                    truedir2='right';
                    if nextmovepos2(2)==51
                        nextmovepos2(2)=1;
                    end
                elseif strcmpi(snakedir2,'up')
                    nextmovepos2=[snakepos2(1,1)-1,snakepos2(1,2)];
                    truedir2='up';
                    if nextmovepos2(1)==0
                        nextmovepos2(1)=50;
                    end
                elseif strcmpi(snakedir2,'down')
                    nextmovepos2=[snakepos2(1,1)+1,snakepos2(1,2)];
                    truedir2='down';
                    if nextmovepos2(1)==51
                        nextmovepos2(1)=1;
                    end
                end
            end
             %%%%%%%%%  SNAKE 3  %%%%%%%%%
            if snake3stat == 1
                if strcmpi(snakedir3,'left')
                    nextmovepos3=[snakepos3(1,1),snakepos3(1,2)-1];
                    truedir3='left';
                    if nextmovepos3(2)==0
                        nextmovepos3(2)=50;
                    end
                elseif strcmpi(snakedir3,'right')
                    nextmovepos3=[snakepos3(1,1),snakepos3(1,2)+1];
                    truedir3='right';
                    if nextmovepos3(2)==51
                        nextmovepos3(2)=1;
                    end
                elseif strcmpi(snakedir3,'up')
                    nextmovepos3=[snakepos3(1,1)-1,snakepos3(1,2)];
                    truedir3='up';
                    if nextmovepos3(1)==0
                        nextmovepos3(1)=50;
                    end
                elseif strcmpi(snakedir3,'down')
                    nextmovepos3=[snakepos3(1,1)+1,snakepos3(1,2)];
                    truedir3='down';
                    if nextmovepos3(1)==51
                        nextmovepos3(1)=1;
                    end
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
            %%%%%snake 2
            if field(nextmovepos2(1),nextmovepos2(2))==5
                growstat2=1;
                %Deleting eaten food
                for count=1:3
                    if isequal(nextmovepos2,foodpos(count,:))
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
                growstat2=0;
            end  
            %%%%%snake 3
            if field(nextmovepos3(1),nextmovepos3(2))==5
                growstat3=1;
                %Deleting eaten food
                for count=1:3
                    if isequal(nextmovepos3,foodpos(count,:))
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
                growstat3=0;
            end  
            
            %Checking snake's forward movement for wall -- snake
            %bump into yourself, and others
            if (field(nextmovepos1(1),nextmovepos1(2))==1)||...
               (field(nextmovepos1(1),nextmovepos1(2))==2)||...     
               (field(nextmovepos1(1),nextmovepos1(2))==3)||...
               (field(nextmovepos1(1),nextmovepos1(2))==4)||...
               (field(nextmovepos1(1),nextmovepos1(2))==10)||...
               (field(nextmovepos1(1),nextmovepos1(2))==11)||...
               (field(nextmovepos1(1),nextmovepos1(2))==9)
                playstat=0;
                failed
                break
            end     
            %computer snake2 bumps player
            if (field(nextmovepos2(1),nextmovepos2(2))==1)||...
               (field(nextmovepos2(1),nextmovepos2(2))==2)||...
               (field(nextmovepos2(1),nextmovepos2(2))==10)||...
               (field(nextmovepos2(1),nextmovepos2(2))==11)||...
               (field(nextmovepos2(1),nextmovepos2(2))==9)
                  snake2stat = 0;    % no grow
                  snakepos2 = zeros(15,2);
            end
            %computer snake3 bumps player
            if (field(nextmovepos3(1),nextmovepos3(2))==1)||...
               (field(nextmovepos3(1),nextmovepos3(2))==2)||...
               (field(nextmovepos3(1),nextmovepos3(2))==3)||...
               (field(nextmovepos3(1),nextmovepos3(2))==4)||...
               (field(nextmovepos3(1),nextmovepos3(2))==9)
                  snake3stat = 0;    % no grow
                  snakepos3 = zeros(15,2);
            end
            % End Checking snake
            
            %Moving snake forward
            %%% snake1
            if growstat1==1
                snakepos1=[nextmovepos1;snakepos1(1:length(snakepos1),:)];
                snakescore1=snakescore1+1;
            else
                snakepos1=[nextmovepos1;snakepos1(1:length(snakepos1)-1,:)];
            end
            %%% snake2
            if growstat2==1
                snakepos2=[nextmovepos2;snakepos2(1:length(snakepos2),:)];
                snakescore2=snakescore2+1;
            elseif growstat2 == 3
                snakepos2=zeros(15,2);
            else
                snakepos2=[nextmovepos2;snakepos2(1:length(snakepos2)-1,:)];
            end
            %%% snake3
            if growstat3==1
                snakepos3=[nextmovepos3;snakepos3(1:length(snakepos3),:)];
                snakescore2=snakescore2+1;
            elseif growstat3 == 3
                snakepos3=zeros(15,2);
            else
                snakepos3=[nextmovepos3;snakepos3(1:length(snakepos3)-1,:)];
            end
            
            %Updating graphics
            field=generatefieldarray(deffield,snakepos1,snakepos2,snakepos3,foodpos);
            drawfield(field)
            %Performing delay
            set(lscoretext,'String',num2str(snakescore1))
            set(rscoretext,'String',num2str(snakescore2))
            % if no remain snake

            if snake2stat == 0 && snake3stat == 0
               transition2 
            end
            % player win
            if snakescore1>=20
                playstat=0;
                transition2
            % computer win
            elseif snakescore2>=20
                playstat=0;
                failed
            end
            pause(0.11-snakevel*0.01)
        end

    end
    %End of startgamefcn

    %Start of closegamefcn
    function closegamefcn(~,~)
        %Stopping game loop
        playstat=0;
        pause(0.5)
        %Closing all windows
        delete(mainwindow)
    end
    %End of closegamefcn
%CodeEnd-----------------------------------------------------------------

end