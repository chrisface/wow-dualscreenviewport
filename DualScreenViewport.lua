function Initialize()
	SetupControlFrame();
	SetupWorldFrame();
	SetMap();

	CreateOverrides();
end

function CreateOverrides()
	StaticPopup_SetUpAnchor = function(dialog, idx)
	    local lastFrame = StaticPopup_DisplayedFrames[idx - 1];
	    if ( lastFrame ) then
	        dialog:SetPoint("TOP", lastFrame, "BOTTOM", 0, 0);
	    else
	        dialog:SetPoint("TOP", WorldFrame, "TOP", 0, -135);
	    end
	end

	GroupLootContainer_Update = function(self)
	    local lastIdx = nil;
	 
	    for i=1, self.maxIndex do
	        local frame = self.rollFrames[i];
	        if ( frame ) then
	            frame:ClearAllPoints();
	            frame:SetPoint("CENTER", WorldFrame, "BOTTOM", 0, self.reservedSize * (i-1 + 0.5));
	            lastIdx = i;
	        end
	    end
	 
	    if ( lastIdx ) then
	        self:SetHeight(self.reservedSize * lastIdx);
	        self:Show();
	    else
	        self:Hide();
	    end
	end


	-- DBM-Core.lua needs to be overriden to this
	-- setRaidWarningPositon = function()

	-- end

end

function SetupWorldFrame()
	WorldFrame:SetScale(0.64);
	WorldFrame:ClearAllPoints();
	WorldFrame:SetPoint("TopLeft");
	WorldFrame:SetPoint("BottomRight", -2135, 0);
	reAlignAllFrames();
end

function SetupControlFrame()
	DualScreenViewport:ClearAllPoints();
	DualScreenViewport:SetPoint("TOPRIGHT");
	DualScreenViewport:SetPoint("BottomLeft", PortalWidth(), 0);
end

function SetMap()
	MinimapBackdrop:Hide();
	Minimap:SetMaskTexture([[Interface\AddOns\DualScreenViewport\Mask-SQUARE]]);
	MinimapCluster:SetParent(DualScreenViewport);
	MinimapCluster:ClearAllPoints();
	MinimapCluster:SetPoint("TopLeft");
	MinimapCluster:SetSize(350,350);

	Minimap:ClearAllPoints();
	Minimap:SetPoint("TopLeft");
	Minimap:SetPoint("BottomRight");
	Minimap:SetSize(350, 350);

	MinimapBorderTop:Hide();
	MiniMapWorldMapButton:Hide();
	MinimapZoomOut:Hide();
	MinimapZoomIn:Hide();
	TimeManagerClockButton:Hide();

	MinimapZoneTextButton:SetFrameStrata("Low");
	MinimapZoneTextButton:ClearAllPoints();
	MinimapZoneTextButton:SetPoint("Top", 0, -5);
	MapIcons();
end

function MapIcons()
	MiniMapTracking:SetParent(Minimap);
	MiniMapTracking:ClearAllPoints();
	MiniMapTracking:SetPoint("TopRight", 30,-60)

	QueueStatusMinimapButton:SetParent(Minimap);
	QueueStatusMinimapButton:ClearAllPoints();
	QueueStatusMinimapButton:SetPoint("TopRight", 30,-80)

	GuildInstanceDifficulty:SetParent(Minimap);
	GuildInstanceDifficulty:ClearAllPoints();
	GuildInstanceDifficulty:SetPoint("TopRight", 30,-100)
end

function PortalWidth()
	return (GetScreenWidth() * WorldFrame:GetEffectiveScale()) / 2;
end

function reAlignAllFrames()
	local kids = { UIParent:GetChildren() };
	for _, child in ipairs(kids) do
		if (child ~= DualScreenViewport and child ~= ChatFrame1 and child ~= ChatFrame2 and child ~= ChatFrame3) then
			reAlignFrame(child)	
		end
	end
end

function reAlignFrame(frame)
	
	pointCount = frame:GetNumPoints();
	points = {};

	for i = 1, pointCount, 1 do
		points[i] = {frame:GetPoint(i)};
	end

	frame:SetParent(WorldFrame);
	frame:ClearAllPoints();

	for i = 1, pointCount, 1 do 
		point, relativeTo , relativePoint, x, y = unpack(points[i]);

		if (relativeTo == UIParent) then
			relativeTo = WorldFrame;
		end
		
		frame:SetPoint(point, relativeTo, relativePoint, x, y);	   

		if (frame == RaidWarningFrame) then
			a,b =RaidWarningFrame:GetPoint(1)
			print(b:GetName())
		end
	end
end