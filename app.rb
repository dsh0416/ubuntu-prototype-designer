require 'qml'

$template = '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
*{outline:0}a,abbr,acronym,address,article,aside,audio,b,big,blockquote,body,canvas,caption,center,cite,code,dd,del,details,dfn,div,dl,dt,em,embed,fieldset,figcaption,figure,footer,form,h1,h2,h3,h4,h5,h6,header,hgroup,html,i,iframe,img,ins,kbd,label,legend,li,menu,nav,ol,output,p,pre,q,s,samp,section,small,span,strike,strong,sub,summary,sup,table,tbody,td,tfoot,th,thead,time,tr,tt,u,ul,var,video{padding:0;margin:0;border:0}body{background:#ededed;font-family:Ubuntu;font-weight:400;color:#787878}@font-face{font-family:Ubuntu;font-style:normal;font-weight:300;src:local("Ubuntu Light"),local("Ubuntu-Light"),url(ubuntu-light.woff) format("woff")}@font-face{font-family:Ubuntu;font-style:normal;font-weight:300;src:local("Ubuntu Light"),local("Ubuntu-Light"),url(ubuntu-light.woff) format("woff")}button,input[type=button]{-webkit-box-shadow:0 2px 2px rgba(100,100,100,.4) inset;box-shadow:0 2px 2px rgba(100,100,100,.4) inset;-webkit-box-sizing:border-box;box-sizing:border-box;display:inline-block;min-width:92px;height:35px;line-height:27px;padding:4px 10px;border:#ABA59F;border-radius:9px/7px;font-family:Ubuntu;font-size:1rem;overflow:hidden;position:relative;text-align:center;text-decoration:none;text-overflow:ellipsis;-webkit-transition:box-shadow 175ms;-moz-transition:box-shadow 175ms;-o-transition:box-shadow 175ms;transition:box-shadow 175ms;vertical-align:middle;white-space:nowrap;background:#ABA59F;color:#fff;width:60%;margin-top:5px}input[type=search],input[type=url],input[type=number],input[type=text],input[type=password],input[type=email],input[type=tel],textarea{-webkit-box-shadow:inset 0 2px 1px rgba(0,0,0,.1);box-shadow:inset 0 2px 1px rgba(0,0,0,.1);background:#cfcfcf;border:0;border-radius:6px;color:#757373;font-family:Ubuntu;font-size:.8rem;padding:8px;width:60%;margin-top:5px}input[type=search]:focus,input[type=url]:focus,input[type=number]:focus,input[type=text]:focus,input[type=password]:focus,input[type=email]:focus,input[type=tel]:focus,textarea:focus{background:#fff;color:#757373;font-family:Ubuntu}input[type=search][disabled],input[type=url][disabled],input[type=number][disabled],input[type=text][disabled],input[type=password][disabled],input[type=email][disabled],input[type=tel][disabled],textarea[disabled]{background:rgba(255,255,255,.1);color:#a9a9a9}input[type=search]:not([value]),input[type=url]:not([value]),input[type=number]:not([value]),input[type=text]:not([value]),input[type=password]:not([value]),input[type=email]:not([value]),input[type=tel]:not([value]),textarea:not([value]){color:#757373}textarea{resize:none;height:80px;width:190px}[data-role=mainview],[data-role=content],body,html{position:relative;width:100%;min-height:100%}[data-role=content]{background:#ededed;border-top:1px solid #f0f0f0;font-size:1rem "Ubuntu";min-height:calc(100% - 75px);color:#787878}[data-role=content] p{font:.9rem Ubuntu;color:#787878;line-height:1.33}[data-role=header]{background:#ededed;height:60px;width:100%;position:fixed;z-index:10}[data-role=header]:after{background:#c2c2c2;content:"";border-top:1px solid #afafaf;height:15px;width:100%;display:block;position:absolute;top:60px}[data-role=headeritem]{position:relative;padding:16px;border-bottom:1px solid #d9d9d9;text-align:left;font-size:1.5rem;cursor:pointer}[data-role=headeritem]:only-child{border-bottom:0}[data-role=headeritem].active{display:none}[data-role=headeritem].inactive,[data-role=contenttab]:first-child{display:block}[data-role=headeritem]:active{background:rgba(0,0,0,.05)}[data-role=contenttab]{-webkit-box-sizing:border-box;box-sizing:border-box;vertical-align:top;width:100%;height:100%;overflow:hidden;display:none}
    </style>
    <title>Title</title>
</head>
<body>
<div data-role="mainview">
    <header data-role="header">
        <div data-role="headeritem" >Project Title</div>
    </header>
    <div data-role="content">
        <div data-role="contenttab"  style= "margin-top: 76px">
            {{page_body}}
        </div>
    </div>
</div>
</body>
</html>'

module AutoBinding
  VERSION = '1.0.0'

  class Ruby
    include QML::Access
    register_to_qml

    property(:html) { '' }
    property(:result) { '' }
    signal :refresh, []
    signal :exported, []

    on_changed :html do
      self.result = $template.clone.gsub(/\{\{page_body\}\}/, html.to_s)
      refresh.emit
    end

    def export
      exported.emit
    end
  end

end

QML.run do |app|
  app.load_path Pathname(__FILE__) + '../qml/app.qml'
end