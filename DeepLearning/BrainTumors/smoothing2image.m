%%
slice = 70;
subplot(1,3,1)
imagesc(shrunk_im(:,:,slice,1));
subplot(1,3,2)
imagesc(scores(:,:,slice));
subplot(1,3,2)
imagesc(shrunk_im(:,:,slice,1) > 0.8);
fullscreen