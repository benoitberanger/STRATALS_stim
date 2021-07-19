function HAND = Hand()
global S

HAND       = PTB_OBJECTS.VIDEO.Hand();
HAND.fpath = fullfile(fileparts(which('project_name')),'img',S.TaskParam.Hand.file);
HAND.LoadImg( S.TaskParam.Hand.autocrop, S.TaskParam.Hand.invert );
HAND.LinkToWindowPtr(S.PTB.Video.wPtr);
HAND.MakeTexture();
HAND.AssertReady();

end % function
