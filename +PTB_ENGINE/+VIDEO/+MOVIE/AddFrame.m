function AddFrame(wPtr, moviePtr)
tic
Screen('AddFrameToMovie',wPtr,[],'backBuffer',moviePtr,1);
toc*1000
end % function
