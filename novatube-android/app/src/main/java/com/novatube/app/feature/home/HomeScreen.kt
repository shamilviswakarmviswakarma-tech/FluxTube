package com.novatube.app.feature.home

import androidx.compose.animation.animateContentSize
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

private val Black = Color(0xFF000000)
private val Surface = Color(0xFF101722)
private val Blue = Color(0xFF1677FF)
private val LightBlue = Color(0xFF54B5FF)
private val Muted = Color(0xFF9BA8BB)

private data class VideoItem(
    val id: Int,
    val title: String,
    val channel: String,
    val meta: String,
    val category: String,
    val duration: String,
    val color: Color
)

private val sampleVideos = listOf(
    VideoItem(1, "भारत का संविधान — महत्वपूर्ण तथ्य", "Study Bharat", "Education • 18 min", "Study", "18:42", Color(0xFF173B63)),
    VideoItem(2, "Technology की दुनिया कैसे बदल रही है?", "Tech Vision", "Technology • 12 min", "Technology", "12:08", Color(0xFF123C48)),
    VideoItem(3, "प्राचीन भारत का रोचक इतिहास", "History Lens", "History • 24 min", "History", "24:16", Color(0xFF49331D)),
    VideoItem(4, "विज्ञान के 10 महत्वपूर्ण सिद्धांत", "Learn Simply", "Science • 15 min", "Science", "15:31", Color(0xFF34234F))
)

@Composable
fun HomeScreen() {
    var query by remember { mutableStateOf("") }
    var category by remember { mutableStateOf("For You") }
    var hideShorts by remember { mutableStateOf(false) }
    var selectedNav by remember { mutableStateOf("Home") }
    var selectedVideo by remember { mutableStateOf<VideoItem?>(null) }

    val categories = listOf("For You", "Videos", "Shorts", "Study", "History", "Technology", "Science")
    val visibleVideos = sampleVideos.filter { video ->
        (category == "For You" || category == "Videos" || category == video.category) &&
            (query.isBlank() || video.title.contains(query, ignoreCase = true) || video.channel.contains(query, ignoreCase = true))
    }

    Scaffold(
        containerColor = Black,
        bottomBar = {
            NavigationBar(containerColor = Color(0xFF080D18), tonalElevation = 0.dp) {
                val destinations = listOf(
                    "Home" to Icons.Outlined.Home,
                    "Explore" to Icons.Outlined.Explore,
                    "Later" to Icons.Outlined.BookmarkBorder,
                    "Playlists" to Icons.Outlined.VideoLibrary,
                    "Library" to Icons.Outlined.FolderOpen
                )
                destinations.forEach { (label, icon) ->
                    NavigationBarItem(
                        selected = selectedNav == label,
                        onClick = { selectedNav = label },
                        icon = { Icon(icon, contentDescription = label) },
                        label = { Text(label, fontSize = 10.sp, maxLines = 1) },
                        colors = NavigationBarItemDefaults.colors(
                            selectedIconColor = LightBlue,
                            selectedTextColor = LightBlue,
                            indicatorColor = Color(0xFF102A48),
                            unselectedIconColor = Muted,
                            unselectedTextColor = Muted
                        )
                    )
                }
            }
        }
    ) { padding ->
        LazyColumn(
            modifier = Modifier.fillMaxSize().padding(padding),
            contentPadding = PaddingValues(start = 16.dp, end = 16.dp, top = 12.dp, bottom = 24.dp),
            verticalArrangement = Arrangement.spacedBy(18.dp)
        ) {
            item {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Box(
                        modifier = Modifier.size(38.dp).clip(RoundedCornerShape(12.dp)).background(Blue),
                        contentAlignment = Alignment.Center
                    ) { Icon(Icons.Outlined.PlayArrow, null, tint = Color.White) }
                    Spacer(Modifier.width(10.dp))
                    Text("NovaTube", fontSize = 23.sp, fontWeight = FontWeight.Bold, color = Color.White, modifier = Modifier.weight(1f))
                    IconButton(onClick = { }) { Icon(Icons.Outlined.Cast, "Cast", tint = Color.White) }
                    IconButton(onClick = { }) { Icon(Icons.Outlined.NotificationsNone, "Notifications", tint = Color.White) }
                    IconButton(onClick = { }) { Icon(Icons.Outlined.AccountCircle, "Profile", tint = LightBlue) }
                }
            }
            item {
                Row(
                    modifier = Modifier.fillMaxWidth().clip(CircleShape).background(Surface).padding(horizontal = 16.dp, vertical = 14.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(Icons.Outlined.Search, null, tint = LightBlue)
                    Spacer(Modifier.width(10.dp))
                    BasicTextField(
                        value = query,
                        onValueChange = { query = it },
                        modifier = Modifier.weight(1f),
                        singleLine = true,
                        textStyle = LocalTextStyle.current.copy(color = Color.White, fontSize = 14.sp),
                        decorationBox = { inner ->
                            if (query.isEmpty()) Text("Search videos, channels, topics...", color = Muted, fontSize = 14.sp)
                            inner()
                        }
                    )
                    Icon(Icons.Outlined.MicNone, "Voice search", tint = LightBlue)
                }
            }
            item {
                Row(Modifier.fillMaxWidth().horizontalScroll(rememberScrollState()), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    categories.forEach { item ->
                        FilterChip(
                            selected = category == item,
                            onClick = { category = item },
                            label = { Text(item) },
                            colors = FilterChipDefaults.filterChipColors(
                                selectedContainerColor = Blue,
                                selectedLabelColor = Color.White,
                                containerColor = Surface,
                                labelColor = Muted
                            ),
                            border = null
                        )
                    }
                }
            }
            item {
                Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Text("Your feed", color = Color.White, fontSize = 18.sp, fontWeight = FontWeight.SemiBold, modifier = Modifier.weight(1f))
                        Icon(Icons.Outlined.Tune, "Feed options", tint = LightBlue)
                    }
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Text("Hide Shorts", color = Muted, fontSize = 13.sp, modifier = Modifier.weight(1f))
                        Switch(
                            checked = hideShorts,
                            onCheckedChange = { hideShorts = it },
                            colors = SwitchDefaults.colors(checkedThumbColor = Color.White, checkedTrackColor = Blue)
                        )
                    }
                }
            }
            item { Text("Recommended for you", color = Color.White, fontSize = 18.sp, fontWeight = FontWeight.SemiBold) }
            if (visibleVideos.isEmpty()) {
                item {
                    Box(Modifier.fillMaxWidth().padding(vertical = 38.dp), contentAlignment = Alignment.Center) {
                        Column(horizontalAlignment = Alignment.CenterHorizontally) {
                            Icon(Icons.Outlined.SearchOff, null, tint = Muted, modifier = Modifier.size(36.dp))
                            Spacer(Modifier.height(8.dp))
                            Text("कोई वीडियो नहीं मिला", color = Muted)
                        }
                    }
                }
            } else {
                items(visibleVideos, key = { it.id }) { video ->
                    VideoCard(video = video, onClick = { selectedVideo = video })
                }
            }
            item {
                Text(
                    "NovaTube • Your Video. Your Knowledge.",
                    color = Color(0xFF65748A),
                    fontSize = 11.sp,
                    modifier = Modifier.fillMaxWidth().padding(top = 8.dp),
                    textAlign = androidx.compose.ui.text.style.TextAlign.Center
                )
            }
        }
    }

    selectedVideo?.let { video ->
        AlertDialog(
            onDismissRequest = { selectedVideo = null },
            containerColor = Surface,
            title = { Text(video.title, color = Color.White) },
            text = { Text("यह अभी Home UI का sample preview है। Video playback अगले module में जोड़ा जाएगा।", color = Muted) },
            confirmButton = {
                TextButton(onClick = { selectedVideo = null }) { Text("ठीक है", color = LightBlue) }
            }
        )
    }
}

@Composable
private fun VideoCard(video: VideoItem, onClick: () -> Unit) {
    Column(
        modifier = Modifier.fillMaxWidth().clip(RoundedCornerShape(18.dp)).background(Surface)
            .clickable(onClick = onClick).animateContentSize()
    ) {
        Box(
            modifier = Modifier.fillMaxWidth().height(190.dp).background(video.color),
            contentAlignment = Alignment.Center
        ) {
            Icon(Icons.Outlined.PlayCircleOutline, null, tint = Color.White.copy(alpha = 0.9f), modifier = Modifier.size(54.dp))
            Text(
                video.duration,
                color = Color.White,
                fontSize = 11.sp,
                modifier = Modifier.align(Alignment.BottomEnd).padding(10.dp)
                    .clip(RoundedCornerShape(5.dp)).background(Color.Black.copy(alpha = 0.8f)).padding(horizontal = 6.dp, vertical = 3.dp)
            )
            Text("NOVATUBE", color = Color.White.copy(alpha = 0.55f), fontSize = 10.sp, letterSpacing = 2.sp)
        }
        Row(Modifier.padding(12.dp), verticalAlignment = Alignment.Top) {
            Box(Modifier.size(38.dp).clip(CircleShape).background(Color(0xFF18345A)), contentAlignment = Alignment.Center) {
                Text(video.channel.take(1), color = LightBlue, fontWeight = FontWeight.Bold)
            }
            Spacer(Modifier.width(10.dp))
            Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(4.dp)) {
                Text(video.title, color = Color.White, fontWeight = FontWeight.SemiBold, maxLines = 2, overflow = TextOverflow.Ellipsis)
                Text(video.channel, color = Muted, fontSize = 12.sp)
                Text(video.meta, color = Muted, fontSize = 11.sp)
            }
            Icon(Icons.Outlined.MoreVert, "More options", tint = Muted)
        }
    }
}
