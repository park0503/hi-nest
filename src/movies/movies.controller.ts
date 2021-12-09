import { Body, Controller, Delete, Get, Param, Patch, Post, Query, Req, Res } from '@nestjs/common';
import { createMovieDTO } from './dto/create-movie.dto';
import { updateMovieDto } from './dto/update-movie.dto';
import { Movie } from './entities/movie.entity';
import { MoviesService } from './movies.service';

@Controller('movies')
export class MoviesController {

  constructor(private readonly movieServie: MoviesService) { }

  @Get()
  getAll(): Movie[] {
    return this.movieServie.getAll();
  }

  @Get("search")
  search(@Query('year') searchingYear: string) {
    return `We are searching for a movie with a title mad after ${searchingYear}`;
  }

  @Get(":id")
  getOne(@Param('id') movieId: number): Movie {
    return this.movieServie.getOne(movieId);
  }

  @Post()
  create(@Body() movieData: createMovieDTO) {
    return this.movieServie.create(movieData);
  }

  @Delete(":id")
  remove(@Param('id') movieId: number) {
    return this.movieServie.deleteOne(movieId);
  }

  @Patch(':id')
  patch(@Param('id') movieId: number, @Body() updateData: updateMovieDto) {
    return this.movieServie.update(movieId, updateData);
  }


}
