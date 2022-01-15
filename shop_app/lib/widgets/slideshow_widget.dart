import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Slideshow extends StatefulWidget {
  final List<Widget> slides;
  final bool pointUp;
  final Color colorPrimary;
  final Color colorSecondary;
  final double bulletPrimary;
  final double bulletSecondary;
  const Slideshow({
    Key? key,
    required this.slides,
    this.pointUp = false,
    this.colorPrimary = Colors.blue,
    this.colorSecondary = Colors.grey,
    this.bulletPrimary = 0.04,
    this.bulletSecondary = 0.04,
  }) : super(key: key);

  @override
  State<Slideshow> createState() => _SlideshowState();
}

class _SlideshowState extends State<Slideshow> {
  final SlideshowModel _slideshowModel = SlideshowModel();
  final pageController = PageController();

  @override
  void initState() {
    pageController.addListener(() {
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
        _slideshowModel.init(context, refresh);
        // print('Página actual: ${pageController.page}');
        _slideshowModel.currentpage = pageController.page!;
      });
      // Update the SliderModel Provider
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Builder(
          builder: (BuildContext context) {
            _slideshowModel._colorPrimary = widget.colorPrimary;
            _slideshowModel._colorSecondary = widget.colorSecondary;
            _slideshowModel._bulletPrimary = widget.bulletPrimary;
            _slideshowModel._bulletSecondary = widget.bulletSecondary;

            return _CreateStructureSlideshow(
              pointUp: widget.pointUp,
              slides: widget.slides,
              slideshowModel: _slideshowModel,
              pageController: pageController,
            );
          },
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}

class _CreateStructureSlideshow extends StatelessWidget {
  const _CreateStructureSlideshow({
    Key? key,
    required SlideshowModel slideshowModel,
    required this.pointUp,
    required this.slides,
    required this.pageController,
  })  : _slideshowModel = slideshowModel,
        super(key: key);
  final bool pointUp;
  final List<Widget> slides;
  final SlideshowModel _slideshowModel;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (pointUp) _Dots(slides: slides, slideshowModel: _slideshowModel),
        Expanded(
            child: PageView(
          controller: pageController,
          physics: const BouncingScrollPhysics(),
          children: slides
              .map(
                (slide) => _Slides(slide: slide),
              )
              .toList(),
        )),
        if (!pointUp) _Dots(slides: slides, slideshowModel: _slideshowModel),
      ],
    );
  }
}

class _Slides extends StatelessWidget {
  final Widget slide;
  const _Slides({
    Key? key,
    required this.slide,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      child: slide,
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({
    Key? key,
    required SlideshowModel slideshowModel,
    required this.slides,
  })  : _slideshowModel = slideshowModel,
        super(key: key);

  final List<Widget> slides;
  final SlideshowModel _slideshowModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.08,
      //color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          slides.length,
          (index) => _Dot(
            size: MediaQuery.of(context).size,
            index: index,
            slideshowModel: _slideshowModel,
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({
    required this.size,
    required this.index,
    required this.slideshowModel,
  });

  final Size size;
  final int index;
  final SlideshowModel slideshowModel;

  @override
  Widget build(BuildContext context) {
    final double sizeBullet;
    final Color colorPoint;

    if (slideshowModel.currentPage >= index - 0.5 &&
        slideshowModel.currentPage < index + 0.5) {
      sizeBullet = slideshowModel._bulletPrimary;
      colorPoint = slideshowModel.colorPrimary;
    } else {
      sizeBullet = slideshowModel._bulletSecondary;
      colorPoint = slideshowModel.colorSecondary;
    }

    return Flexible(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size.width * sizeBullet,
        height: size.height * sizeBullet,
        margin: EdgeInsets.symmetric(horizontal: size.width * 0.02),
        decoration: BoxDecoration(
          color: colorPoint,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class SlideshowModel {
  late BuildContext context;
  late Function refresh;

  double _currentPage = 0;
  Color _colorPrimary = Colors.blue;
  Color _colorSecondary = Colors.grey;

  double _bulletPrimary = 0.04;
  double _bulletSecondary = 0.04;

  void init(BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;
  }

  set currentpage(double index) {
    _currentPage = index;
    refresh();
  }

  set colorPrimary(Color color) {
    _colorPrimary = color;
    refresh();
  }

  set colorSecondary(Color color) {
    _colorSecondary = color;
    refresh();
  }

  set bulletPrimary(double vaule) {
    _bulletPrimary = vaule;
    refresh();
  }

  set bulletSecondary(double vaule) {
    _bulletSecondary = vaule;
    refresh();
  }

  double get currentPage => _currentPage;

  Color get colorPrimary => _colorPrimary;
  Color get colorSecondary => _colorSecondary;

  double get bulletPrimary => _bulletPrimary;
  double get bulletSecondary => _bulletSecondary;
}
