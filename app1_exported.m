classdef app1_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure  matlab.ui.Figure
        Image     matlab.ui.control.Image
        Button    matlab.ui.control.Button
        Button_2  matlab.ui.control.Button
        Label     matlab.ui.control.Label
    end

    
    methods (Access = private)
        
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 741 481];
            app.UIFigure.Name = 'MATLAB App';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.ScaleMethod = 'fill';
            app.Image.Position = [-2 1 744 481];
            app.Image.ImageSource = 'ÿÿÿÿÿÿÿÿ-ÿÿÿ.gif';

            % Create Button
            app.Button = uibutton(app.UIFigure, 'push');
            app.Button.FontSize = 18;
            app.Button.Position = [281 164 179 32];
            app.Button.Text = 'ÿÿÿÿ';

            % Create Button_2
            app.Button_2 = uibutton(app.UIFigure, 'push');
            app.Button_2.FontSize = 16;
            app.Button_2.Position = [309 106 128 29];
            app.Button_2.Text = {'ÿÿ'; ''};

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.FontName = 'Noto Sans CJK TC';
            app.Label.FontSize = 48;
            app.Label.FontWeight = 'bold';
            app.Label.FontColor = [1 1 1];
            app.Label.Position = [194 354 353 78];
            app.Label.Text = 'ÿ ÿ ÿ ÿ ÿ ÿ';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app1_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end