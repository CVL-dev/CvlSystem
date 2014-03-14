#!/usr/bin/python

import wx, wx.html, getopt 
import sys, os

position = (80, 0)
html_window = (800, 390)
frame_size = (800, 520)

class HtmlWindow(wx.html.HtmlWindow):
    def __init__(self, parent, id, size = (500,500)):
        wx.html.HtmlWindow.__init__(self,parent, id, size=size)
        if "gtk2" in wx.PlatformInfo:
            self.SetStandardFonts()
    
    def OnLinkClicked(self, link):
        wx.LaunchDefaultBrowser(link.GetHref())

class DialogBox(wx.Dialog):
    def __init__(self, parent, title, message):
        wx.Dialog.__init__(self, parent=parent, title=title, pos = position)

        grid = wx.GridBagSizer(2,2)
        hwin = HtmlWindow(self, -1, size = (500,500))
        vers = {}
        vers["python"] = sys.version.split()[0]
        vers["wxpy"] = wx.VERSION_STRING
        hwin.SetPage(message % vers)
        btn = hwin.FindWindowById(wx.ID_OK)
        irep = hwin.GetInternalRepresentation()
        hwin.SetSize((irep.GetWidth()+25, irep.GetHeight()+10))
        grid.Add(hwin, pos=(0,0))
        btns = self.CreateSeparatedButtonSizer(wx.OK)
        mainSizer = wx.BoxSizer(wx.VERTICAL)
        mainSizer.Add(grid, 1, wx.ALL|wx.EXPAND)
        mainSizer.Add(btns, 0, wx.ALL|wx.EXPAND)
        self.SetSizer(mainSizer)
        self.Fit()

class SetupForm(wx.Frame):
 
    def __init__(self,  messageFile, title, installFile, cleanFlag = False):
        messageFile = messageFile
        self.title = title 
        self.installFile = installFile 
        self.cleanFlag = cleanFlag
        self.setup(messageFile)

    def setup(self, messageFile):
        wx.Frame.__init__(self, None, wx.ID_ANY, pos = position, size = frame_size, title = self.title) 
        self.panel = wx.Panel(self, wx.ID_ANY)
        self.panel.SetBackgroundColour(wx.WHITE)

        fileHandle = open(messageFile, "r")
        message = fileHandle.read()
        fileHandle.close()

        vers = {}
        vers["python"] = sys.version.split()[0]
        vers["wxpy"] = wx.VERSION_STRING
        hwin = HtmlWindow(self.panel, -1, size = html_window)

        hwin.SetPage(message % vers)
        
	email_address = ""
        if os.path.exists(self.installFile):
            handle = open(self.installFile, "r")
            email_address = handle.read()
            handle.close()
            
        emailLabel = wx.StaticText(self.panel, label="Enter your email address:")
        self.emailAddress = wx.TextCtrl(self.panel, value=email_address, size=(230, -1))
        emailSizer = wx.BoxSizer(wx.HORIZONTAL)
        emailSizer.Add(emailLabel, 0, wx.ALL, 5)
        emailSizer.Add(self.emailAddress, 0, wx.ALL, 5)
 
        saveButton = wx.Button(self.panel, wx.ID_ANY, 'Save')        
        runButton = wx.Button(self.panel, wx.ID_ANY, 'Run')        
        cancelButton = wx.Button(self.panel, wx.ID_ANY, 'Cancel')
        self.Bind(wx.EVT_BUTTON, self.OnSave, saveButton)
        self.Bind(wx.EVT_BUTTON, self.OnCancel, cancelButton)
        self.Bind(wx.EVT_BUTTON, self.OnRun, runButton)
        
        emailSizer.Add(saveButton, 0, wx.ALL, 5)
 
        buttonSizer = wx.BoxSizer(wx.HORIZONTAL)
 
        buttonSizer.Add(runButton, 0, wx.ALL, 5)
        buttonSizer.Add(cancelButton, 0, wx.ALL, 5)

        if self.cleanFlag:
            cleanButton = wx.Button(self.panel, wx.ID_ANY, 'Clean')
            self.Bind(wx.EVT_BUTTON, self.OnClean, cleanButton)
            buttonSizer.Add(cleanButton, 0, wx.ALL, 5)


        gridSizer = wx.GridBagSizer(10, 1)
        gridSizer.Add(hwin, pos = (0, 0))
        gridSizer.Add(emailSizer, pos = (2, 0))
        gridSizer.Add(buttonSizer, pos = (3, 0))
        self.panel.SetSizer(gridSizer)

    def OnSave(self, event):
        emailFileHandle = open(self.installFile, "w")
        emailFileHandle.write(self.emailAddress.GetValue())
        emailFileHandle.close()
 
    def OnCancel(self, event):
        print "Cancel"
        self.Done()
    
    def OnRun(self, event):
        print "Run"
        self.Done()
 
    def OnClean(self, event):
        confirm = wx.MessageDialog(self, "Do you really want to clean the configuration and local directories?", "Confirm Exit", wx.OK|wx.CANCEL|wx.ICON_QUESTION)
        result = confirm.ShowModal()
        confirm.Destroy()
        if result == wx.ID_OK:
            print "Clean"
            self.Done()

    def Done(self):
        self.Close()
 
class Setup:
    def __init__(self, messageFile, title, installFile, cleanFlag = False):
        self.messageFile = messageFile
        self.title = title
        self.installFile = installFile 
        self.cleanFlag = cleanFlag
        self.show()

    def show(self):
        app = wx.App(False)
        setupForm = SetupForm(self.messageFile, self.title, self.installFile, self.cleanFlag)
        setupForm.Show()
        app.MainLoop()
    
def Usage():
    print "Usage: cvl_cloudstor_setup.py  -m | --message <message> -e | --email <Email file>"
    print "Usage: cvl_cloudstor_setup.py -h | --help"
    return True

def main(argv):
    
    message = ""
    emailFile = ""
    cleanFlag = False
    title = "AARNET CloudStor+ account setup"
    
    if len(sys.argv) < 2:
        return Usage()

    try:
        options, arguments = getopt.getopt(argv,"chm:e",["clean", "help", "message=", "email="])
    except getopt.GetoptError:
        print "option exception"
        return Usage()

    for option, arg in options:
        if option in ("-h", "--help"):
            return Usage()
        elif option in ("-m", "--message"):
            message = arg
        elif option in ("-e", "--email"):
            emailFile = arg
        elif option in ("-c", "--clean"):
            cleanFlag = True 
        else:
            return Usage()

    Setup( message, title, emailFile, cleanFlag) 

if __name__ == '__main__':
    main(sys.argv[1:])

