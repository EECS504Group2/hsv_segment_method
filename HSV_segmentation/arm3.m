figure(1)
fontSize = 10;
rgbimage=imread('41.jpg');
rgbimage = imrotate(rgbimage, 270);
[row, col, chan] = size(rgbimage);

subplot(3, 3, 1);
imshow(rgbimage);
title('Original Color Image', 'FontSize', fontSize);

hsvimage = rgb2hsv(rgbimage);
h_image = hsvimage(:,:,1); % Hue
s_image = hsvimage(:,:,2); % Saturation
v_image = hsvimage(:,:,3); % Value

[pixelCount, grayLevels] = hist(s_image(:), 200); % 200 is used as a size
subplot(3, 3, 7); 
bar(grayLevels, pixelCount); % Plot a bar chart. grayLevels: xaxis, pixelCount: yaxis
grid on;
title('Histogram of S image', 'FontSize', fontSize, 'Interpreter', 'None');
xlabel('Gray Level', 'FontSize', fontSize);
ylabel('Pixel Count', 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.

% Display the HSV images.
subplot(3, 3, 2);
imshow(h_image, []);
title('Hue Image', 'FontSize', fontSize);
subplot(3, 3, 3);
imshow(s_image, []);
title('Saturation Image', 'FontSize', fontSize);
subplot(3, 3, 4);
imshow(v_image, []);
title('Value Image', 'FontSize', fontSize);


mask = s_image > 0.18; % Or whatever value works.
% Display the image.
subplot(3, 3, 5);
imshow(mask);
title('Mask Image', 'FontSize', fontSize);

maskedRgbImage = bsxfun(@times, rgbimage, cast(mask, 'like', rgbimage));
% Display the image.
subplot(3, 3, 6);
imshow(maskedRgbImage);
title('Masked RGB Image', 'FontSize', fontSize, 'Interpreter', 'None');

AA = maskedRgbImage(:,:,1);
AA(AA==0) = []; AAA = sum(AA(:))/size(AA,2);
BB = maskedRgbImage(:,:,2);
BB(BB==0) = []; BBB = sum(BB(:))/size(BB,2);
CC = maskedRgbImage(:,:,3);
CC(CC==0) = []; CCC = sum(CC(:))/size(CC,2);

% realimage=imread('36.jpg');
% row2 = size(realimage,1); col2 = size(realimage,2);
% seg = zeros(row2, col2);
% for i = 1:row2
%     for j = 1:col2
%         if realimage(i,j,1) < 1.2*AAA && realimage(i,j,1) > 0.8*AAA ...
%                && realimage(i,j,2) < 1.2*BBB && realimage(i,j,2) > 0.8*BBB ...
%                && realimage(i,j,3) < 1.2*CCC && realimage(i,j,3) > 0.8*CCC
%            seg(i,j) = 1;
%         else
%            seg(i,j) = 0;
%         end
%     end
% end
% subplot(3,3,8);
% imshow(realimage,[]);
% subplot(3,3,9);
% imshow(seg,[]);     


% %IMAGE SEGMENTATION
% img=imread('C:\\Users\\insungh\\Desktop\\Winter 2018\\Foundations of computer vision\\Project\\arm\\34.jpg');
% img=rgb2ycbcr(img);
% for i=1:size(img,1)
%     for j= 1:size(img,2)
%         cb = img(i,j,2);
%         cr = img(i,j,3);
%         if(~(cr > 132 && cr < 173 && cb > 76 && cb < 126))
%             img(i,j,1)=235;
%             img(i,j,2)=128;
%             img(i,j,3)=128;
%         end
%     end
% end
% img=ycbcr2rgb(img);
% subplot(2,2,1);
% image1=imshow(img);
% axis on;
% title('Skin Segmentation', 'FontSize', 12);
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% %SEGMENTED IMAGE TO GRAYIMAGE
% grayImage=rgb2gray(img);
% subplot(2,2,2);
% image2=imshow(grayImage);
% axis on;
% title('Original Grayscale Image', 'FontSize', 12);
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% %GRAY TO BINARY IMAGE
% binaryImage = grayImage < 245;
% subplot(2, 2, 3);
% axis on;
% imshow(binaryImage, []);
% title('Binary Image', 'FontSize', 12);
% % Label the image 
% labeledImage = bwlabel(binaryImage);  % labeling is the process of identifying the connected components in an image and assigning each one a unique label, like this:
% measurements = regionprops(labeledImage, 'BoundingBox', 'Area');
% for k = 1 : length(measurements)
%   thisBB = measurements(k).BoundingBox;
%   rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
%   'EdgeColor','r','LineWidth',2 )
% end
% 
% 
% % Let's extract the second biggest blob - that will be the hand.
% allAreas = [measurements.Area];
% [sortedAreas, sortingIndexes] = sort(allAreas, 'descend');
% handIndex = sortingIndexes(2); % The hand is the second biggest, face is biggest.
% % Use ismember() to extact the hand from the labeled image.
%  handImage = ismember(labeledImage, handIndex);
% % Now binarize
% handImage = handImage > 0;
% % Display the image.
% subplot(2, 2, 4);
% imshow(handImage, []);
% title('Hand Image', 'FontSize', 12);

% subplot(3,3,10)
% figure
% mask_img = immultiply(maskedRgbImage,ones(size(maskedRgbImage)));
% imshow(mask_img)

%matlab kmeans clustering color segmentation example
lab_he = rgb2lab(maskedRgbImage);
ab = lab_he(:,:,2:3);
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

figure(2)
nColors = 5;
% repeat the clustering 3 times to avoid local minima
[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',3);
pixel_labels = reshape(cluster_idx,nrows,ncols);
imshow(pixel_labels,[]), title('image labeled by cluster index');
figure(3)
subplot(2,3,1)
imshow(segmented_images{1}), title('objects in cluster 1');

subplot(2,3,2)
imshow(segmented_images{2}), title('objects in cluster 2');

subplot(2,3,3)
imshow(segmented_images{3}), title('objects in cluster 3');

subplot(2,3,4)
imshow(segmented_images{4}), title('objects in cluster 4');

subplot(2,3,5)
imshow(segmented_images{5}), title('objects in cluster 5');